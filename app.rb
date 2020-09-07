require_relative "./app/player"
require_relative "./app/room"
require_relative "./app/map"
require_relative "./app/utility"
require_relative "./app/map_loader"

require 'yaml'
require 'pp'

Dir["./encounters/*.rb"].each do |file_name|
  require_relative file_name
end

class App
  DEFAULT_MAP_FILE = './maps/default.yaml'
  
  def initialize(input: $stdin, output: $stdout, avatar: nil, map: nil)
    @input = input
    @output = output
    @avatar = avatar || Player.new(self)
    @current_map = Map.new(map || load_map_from_file(DEFAULT_MAP_FILE))
    
    move_avatar(*@current_map.start, initializing: true)
  end  
  
  def load_map_from_file(filename)
    MapLoader.new(YAML.load_file(filename)).generate
  end
  
  def save_state
   self.to_h
  end
  
  def to_h
    {
      avatar: @avatar.to_h,
      current_map: @current_map.to_h
    }
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
     text.read.lines.map { |line| line.strip.center(74) }.join("\n")
    end
  end

  def current_room
    y, x = @avatar.location
    @current_map.level[y][x]
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
    update = { 
      "north" => [@avatar.location[0] - 1, @avatar.location[1] + 0, "south"],
      "east" => [@avatar.location[0]  + 0, @avatar.location[1] + 1, "west"],
      "south" => [@avatar.location[0] + 1, @avatar.location[1] + 0, "north"],
      "west" => [@avatar.location[0]  + 0, @avatar.location[1] - 1, "east"],
      }
    
    case nesw
      when @avatar.back then move_avatar(*update.fetch(nesw))
      when *current_room.lay
        if current_room.enc.blocking 
          "You'll have to deal with this or go back."
        else
          move_avatar(*update.fetch(nesw))
        end
      else
        "That's a wall dummy."
    end
  end
  
  def move_avatar(new_y, new_x, back, initializing: false)
    @avatar.location[0] = new_y
    @avatar.location[1] = new_x
    @avatar.back = back
    
    return if initializing
    
    if @avatar.location == @current_map.win
      game_over("You Win!\nYou manage to leave alive. Huzzah!\n #{check_inventory}")
    else
      "You walk to the next room."
    end
  end
  
  def game_over(msg)
    display msg 
    exit(0)
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
    # Want to see if the hash used in testing is helpful here but I don't see it yet 
    
    display case first
            when nil
              missing_command
            when "debug"
              debug
            when "debuggame"
              debug_game
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
              game_over("You give up and die in the maze! Game Over!")
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
  end
  
  def check_with_encounter(cmdstr)
   result = current_room.enc.handle_command(cmdstr, @avatar)
   unless result
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
  
  def debug_game
    Utility.debug_game(self)
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
  
  # logically public: 
  #   App.display, App.initialize
  #   Game.initialize, Game.text_block, Game.handle_command, Game.look (talk to meg re: look)
  # Through handle_command, add:
  #   move_avatar
  #   attempt_to_walk
  #   check_inventory
  #   move_item
  #   check_with_encounter
end
