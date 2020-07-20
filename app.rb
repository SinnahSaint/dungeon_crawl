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
      a: Template.new(encounter: ->{Avalanche.new}, inventory:["pole", "pebble"], description: "A dusty room full of rubble."),
      c: Template.new(encounter: ->{Cow.new}, description: "A mostly empty room with straw on the floor."),
      i: Template.new(encounter: ->{Ice.new}, description: "This room is really cold for no good reason."),
      j: Template.new(encounter: ->{Jester.new}, description: "A throne room, with no one on the throne."),
      f: Template.new(encounter: ->{Fire.new}, inventory: ["knife"], description: "A kitchen with a nice table."),
      g: Template.new(inventory:["gold"], description: "A lovely room filled with gold."),
      n: Template.new(description: "A literally boring nothing room."),
    }

    @map = [
      [Room.new(@lay[:es], @temp[:f]), Room.new(@lay[:esw], @temp[:n]), Room.new(@lay[:w], @temp[:a])],
      [Room.new(@lay[:ns], @temp[:n]), Room.new(@lay[:n], @temp[:g]),   Room.new(@lay[:s], @temp[:c])],
      [Room.new(@lay[:ne], @temp[:j]), Room.new(@lay[:esw], @temp[:n]), Room.new(@lay[:nw], @temp[:i])]
    ]
    
  end
  
  def current_room
   @map[@avatar.location[0]][@avatar.location[1]]
   end
    

  
  def inventory
    unless @avatar.inventory.empty?
      puts "Your inventory includes:"
      @avatar.inventory.each { |n| puts " * #{n}" }
    else
      puts "You're not carrying anything."
    end
  end


  def help
    # want to make this a lil more complex later by giving encounter specific hints
    puts "Help & Hints"
    puts "-------------"
    puts "* The goal is to find the gold, and get out of the dungeon safely, carrying as many things as you can find."
    puts "* Entering 'i' will get you to your inventory."
    puts "* Entering 'look' will tell you about the room you're in."
    puts "* Enter a cardinal direction & you will try to move that way."
    puts "* Key words like 'use' and 'take' will let you interact with items."
    puts "* Encounters in the dungeon may want an item to let you pass, or they may want you to do something else."
    puts "* Good luck and have fun! Entering '?' will get you back to this help text."
    puts "------------"
  end

  def leave
    puts "You manage to leave alive. Huzzah!"
    inventory
    exit(0)
  end

  def go(direction)
    case direction
    when "n"  then nesw = "north"
    when "e"  then nesw = "east"
    when "s"  then nesw = "south"
    else  nesw = "west"
    end
        
    case nesw
    when @avatar.back 
      change_room(nesw)
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
      leave
    end
    
    look
  end

  def look
    puts current_room.description
    puts current_room.enc.state
    
    unless current_room.inventory.empty?
      puts "In this room you can see: #{Utility.english_list(current_room.inventory)}"
    else
      puts "You don't see any interesting items here."
    end
    
    puts "There are exits to the #{Utility.english_list(current_room.lay)}"
  end

  def move_item(item,from,to)
    if from.inventory.include?(item)
    from.remove_item(item)
    to.inventory << item
    end
  end

  def handle_command(cmdstr)
    first, second = cmdstr.split(" ")
    case first
    when "use"
      unless @avatar.has_item?(second)
        puts "Whoops! No #{second} in inventory."
        return
      end
                  
      if current_room.enc.handle_command(cmdstr)
        @avatar.remove_item(second)
      end
      
    when "take"
      if move_item(second, current_room, @avatar)
        puts "You pick up the #{second}."
      else
        puts "Whoops! No #{second} here."
      end
      
    when "drop"
      if move_item(second, @avatar, current_room)
        puts "You drop the #{second}."
      else
        puts "Whoops! No #{second} in inventory."
      end
      
    else
      current_room.enc.handle_command(cmdstr)
    end

  end
  
  def user_input
    look
    while true
      puts "- " * 20
      puts "What's next?"
      command = gets.chomp.downcase
      
      case command
      when "debug"  then Utility.debug(current_room, @avatar)
      when "?"      then help
      when "i"      then inventory
      when "look"   then look
      when "quit", "exit"   then break
      else handle_command(command)
      when "north", "east", "south", "west", "n", "e", "s", "w" then go(command)
      end
    end
    puts "You die in the maze! Bye, Felicia!"
  end
  
end


Application.new.user_input
