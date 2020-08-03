require_relative "./player"
require_relative "./template"
require_relative "./room"
require_relative "./utility"
Dir["./encounters/*.rb"].each do |file_name|
  require_relative file_name
end

class App
  def initialize(input: $stdin, output: $stdout, avatar: nil, map: nil, map_start: nil)
    @input = input
    @output = output
    @avatar = avatar || Player.new(self)
    @map = map || choose_map
    @map_start = map_start || [2, 1, "south"]
    move_avatar(*@map_start, initializing: true)
  end
  
  def choose_map
    temp = {
      a: Template.new(encounter: ->{Avalanche.new}, inventory:["gemstone"], description: "A dusty room full of rubble. "),
      c: Template.new(encounter: ->{Cow.new}, description: "A mostly empty room with straw on the floor. "),
      f: Template.new(encounter: ->{Fire.new}, inventory: ["knife"], description: "A kitchen with a nice table. "),
      i: Template.new(encounter: ->{Ice.new}, description: "This room is really cold for no good reason. "),
      j: Template.new(encounter: ->{Jester.new}, description: "A throne room, with no one on the throne. "),
      k: Template.new(encounter: ->{Killer.new}, description: "This room looks like you walked into a bandit's home office. "),
      g: Template.new(inventory:["gold"], description: "A lovely room filled with gold. "),
      n: Template.new(description: "A literally boring nothing room. "),
    }
    
    lay = {
      n: %w[north],
      e: %w[east],
      s: %w[south],
      w: %w[west],
      ne: %w[north east],
      ns: %w[north south],
      nw: %w[north west],
      es: %w[east south],
      ew: %w[east west],
      sw: %w[south west],
      nes: %w[north east south],
      new: %w[north east west],
      nsw: %w[north south west],
      esw: %w[east south west],
      nesw: %w[north east south west]
    }
    
    [[Room.new(lay[:es], temp[:f]), Room.new(lay[:esw], temp[:k]), Room.new(lay[:w], temp[:a])],
     [Room.new(lay[:ns], temp[:n]), Room.new(lay[:n], temp[:g]),   Room.new(lay[:s], temp[:c])],
     [Room.new(lay[:ne], temp[:j]), Room.new(lay[:esw], temp[:n]), Room.new(lay[:nw], temp[:i])]
    ]
  end
  
  def run
    display text_block("intro")
    look
    
    loop do
      command = interface
      handle_command(command)
      display " - - - "
      look
    end  
  end
  
  def interface
    display "- " * 20
    @output.print "What's next? > "
    @input.gets.chomp.downcase
  end

  
  def display(msg)
    @output.puts msg
  end
  
  def text_block(file_name)
    file = "./text_blocks/" + file_name + ".txt"
    
    File.open(file, 'r') do |text|
     text.read.lines.map { |line| line.strip.center(76) }.join("\n")
    end
  end

  def current_room
    y, x = @avatar.location
    @map[y][x]
  end
 
  def check_inventory
    unless @avatar.inventory.empty?
      lines = @avatar.inventory.map { |item| " * #{item}" }.join("\n")
      "Your inventory includes: \n#{lines} "
    else
      "You're not carrying anything."
    end
  end

  def attempt_to_walk(nesw)
    case nesw
      when @avatar.back then walk(nesw)
      when *current_room.lay
        if current_room.enc.blocking 
          "You'll have to deal with this or go back."
        else
          walk(nesw)
        end
      else
        "That's a wall dummy."
    end
  end
  
  def walk(nesw)
    case nesw
      when "north" then move_avatar(@avatar.location[0] - 1, @avatar.location[1],     "south")
      when "east"  then move_avatar(@avatar.location[0],     @avatar.location[1] + 1, "west")
      when "south" then move_avatar(@avatar.location[0] + 1, @avatar.location[1],     "north")
      when "west"  then move_avatar(@avatar.location[0],     @avatar.location[1] - 1, "east")
      else display "can't move."
    end
  end
  
  def move_avatar(new_y, new_x, back, initializing: false)
    @avatar.location[0] = new_y
    @avatar.location[1] = new_x
    @avatar.back = back
    
    return if initializing
    
    if @avatar.location[0] >= 3 
      game_over("You Win!\nYou manage to leave alive. Huzzah!\n #{check_inventory}")
    else
      "You walk to the next room."
    end
  end
  
  def game_over(msg)
    display msg 
    exit(0)
  end

  def look
    display current_room.description
    display current_room.enc.state unless current_room.enc.state == ""
    unless current_room.inventory.empty?
      display "In this room you can see: #{Utility.english_list(current_room.inventory)}"
    else
      display "You don't see any interesting items here."
    end  
   
    doors = current_room.lay - @avatar.back.split(" ")
    unless doors.empty?
    display "There are exits to the #{Utility.english_list(doors)}, or #{@avatar.back}, back the way you came."
    else
    display "The only exit is to the #{@avatar.back}, back the way you came."
    end
  end

  def move_item(item,from,to)
    if from.inventory.include?(item)
    from.remove_item(item)
    to.inventory << item
    end
  end

  def missing_command
    "Type in what you want to do. Try ? if you're stuck."
  end


  def handle_command(cmdstr)
    first, second, third, fourth = cmdstr.split(" ")  
    
    msg = (
      case first
      when nil
        missing_command
      when "debug"
        debug
      when "teleport"
        teleport(second.to_i, third.to_i, fourth)
      when "north", "n"
        attempt_to_walk("north")
      when "east", "e"
        attempt_to_walk("east")
      when "south", "s"
        attempt_to_walk("south")
      when "west", "w" 
        attempt_to_walk("west")
      when "?", "help"              
        text_block("help")
      when "hint"
        hint
      when "i", "inv", "inventory"
        check_inventory
      when "quit", "exit"
        game_over("You die in the maze! Bye, Felicia!")
      when "take"
        if move_item(second, current_room, @avatar)
          "You pick up the #{second}. "
        else
          "Whoops! No #{second} here. "
        end 
      when "drop"
        if move_item(second, @avatar, current_room)
          "You drop the #{second}. "
        else
          "Whoops! No #{second} in inventory. "
        end
      else
        check_with_encounter(cmdstr)
      end
    )   
    display msg
  end
  
  def check_with_encounter(cmdstr)
   result = current_room.enc.handle_command(cmdstr, @avatar)
   if result == false
    result = "Trying to #{cmdstr} won't work right now."
   end
   result
  end
  
  private
  
  def teleport(y, x, back)
    raise "RTFM Shannon" if back.nil?
    move_avatar(y, x, back)
    "BANFF"
  end

  def hint
    current_room.enc.hint
  end 
  
  def debug
    Utility.debug(current_room, @avatar)
  end
  
  # logically public: 
  #   App.display, App.initialize
  #   Game.initialize, Game.text_block, Game.handle_command, Game.look
  # Through handle_command, add:
  #   move_avatar
  #   attempt_to_walk
  #   check_inventory
  #   move_item
  #   check_with_encounter
end
