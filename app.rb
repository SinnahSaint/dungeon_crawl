require_relative "./player"
require_relative "./template"
require_relative "./room"
require_relative "./utility"
Dir["./encounters/*.rb"].each do |file_name|
  require_relative file_name
end

class Application
  
  def initialize
    @avatar = Player.new
    @lay = {
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

    @temp = {
      a: Template.new(encounter: ->{Avalanche.new}, inventory:["gemstone"], description: "A dusty room full of rubble. "),
      c: Template.new(encounter: ->{Cow.new}, description: "A mostly empty room with straw on the floor. "),
      f: Template.new(encounter: ->{Fire.new}, inventory: ["knife"], description: "A kitchen with a nice table. "),
      i: Template.new(encounter: ->{Ice.new}, description: "This room is really cold for no good reason. "),
      j: Template.new(encounter: ->{Jester.new}, description: "A throne room, with no one on the throne. "),
      k: Template.new(encounter: ->{Killer.new}, description: "This room looks like you walked into a bandit's home office. "),
      g: Template.new(inventory:["gold"], description: "A lovely room filled with gold. "),
      n: Template.new(description: "A literally boring nothing room. "),
    }

    @map = [
      [Room.new(@lay[:es], @temp[:f]), Room.new(@lay[:esw], @temp[:k]), Room.new(@lay[:w], @temp[:a])],
      [Room.new(@lay[:ns], @temp[:n]), Room.new(@lay[:n], @temp[:g]),   Room.new(@lay[:s], @temp[:c])],
      [Room.new(@lay[:ne], @temp[:j]), Room.new(@lay[:esw], @temp[:n]), Room.new(@lay[:nw], @temp[:i])]
    ]
    
    @map_start = ["2,1", "south", @avatar]
  end
  
  def text_block(file_name)
    file = "./text_blocks/" + file_name.to_s + ".txt"
    
    File.open(file) do |text|
     text.read
    end
  end

  def current_room
    y, x = @avatar.location
    @map[y][x]
  end
 
  def check_inventory
    unless @avatar.inventory.empty?
      puts "Your inventory includes:"
      @avatar.inventory.each { |n| puts " * #{n}" }
    else
      puts "You're not carrying anything."
    end
  end

  def go(direction)
    case direction
      when "n"  then nesw = "north"
      when "e"  then nesw = "east"
      when "s"  then nesw = "south"
      when "w"  then nesw = "west"
      else  nesw = direction
    end   
    case nesw
      when @avatar.back then change_room(nesw)
      when *current_room.lay
        if current_room.enc.blocking 
          puts "You'll have to deal with this or go back."
        else
          change_room(nesw)
        end
      else
        puts "That's a wall dummy."
    end
  end
  
  def change_room(nesw)
    case nesw
      when "north"  
        @avatar.location[0] -= 1
        @avatar.back = "south"
      when "east"   
        @avatar.location[1] += 1
        @avatar.back = "west"
      when "south"  
        @avatar.location[0] += 1
        @avatar.back = "north"
      when "west"  
        @avatar.location[1] -= 1
        @avatar.back = "east"
      else
        puts "can't move."
    end
    if @avatar.location[0] >= 3 
      @avatar.leave("win", "You manage to leave alive. Huzzah!")
    end
    look
  end

  def look
    print current_room.description
    puts current_room.enc.state  
    unless current_room.inventory.empty?
      puts "In this room you can see: #{Utility.english_list(current_room.inventory)}"
    else
      puts "You don't see any interesting items here."
    end  
   
    doors = current_room.lay - @avatar.back.split(" ")
    unless doors.empty?
    puts "There are exits to the #{Utility.english_list(doors)}, or #{@avatar.back}, back the way you came."
    else
    puts "The only exit is to the #{@avatar.back}, back the way you came."
    end
  end

  def move_item(item,from,to)
    if from.inventory.include?(item)
    from.remove_item(item)
    to.inventory << item
    end
  end

  def handle_command(cmdstr)
    first, second, third = cmdstr.split(" ")  
    
      tf, msg = (
        case first
        when "debug"
          [true, Utility.debug(current_room, @avatar)]
        when "teleport"
          [true, Utility.teleport(second, third, @avatar)]
        when "north", "east", "south", "west", "n", "e", "s", "w" 
          [true, go(first)] 
        when "?", "help"              
          [true, text_block("help")]
        when "hint"
          [true, current_room.enc.hint]
        when "i", "inv", "inventory"
          [true, check_inventory]
        when "look", "look room"
          [true, look]
        when "quit", "exit"
          [true, @avatar.leave("die", "You die in the maze! Bye, Felicia!", @avatar)]  
        when "take"
          if move_item(second, current_room, @avatar)
            [true, "You pick up the #{second}. "]
          else
            [false, "Whoops! No #{second} here. "]
          end 
        when "drop"
          if move_item(second, @avatar, current_room)
            [true, "You drop the #{second}. "]
          else
            [false, "Whoops! No #{second} in inventory. "]
          end
        when "use"
          if @avatar.has_item?(second)
            current_room.enc.handle_command(cmdstr, @avatar)
          else
            [false, "Whoops! No #{second} in inventory. "]
          end
        else
          current_room.enc.handle_command(cmdstr, @avatar)
        end
        )
    puts msg
    tf
  end
  
  def run
    puts text_block("intro")
    Utility.teleport(*@map_start)
    look
    
    loop  do
      puts "- " * 20
      print "What's next? > "
      command = gets.chomp.downcase
  
        if command.empty?
          puts "Type in what you want to do. Try ? if you're stuck."
        elsif handle_command(command)
          look
        else
          puts "Trying to #{command} won't work here."
        end
    end  
  end
  
end

Application.new.run
