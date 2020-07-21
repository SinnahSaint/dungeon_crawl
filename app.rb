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
  
  def intro
    <<~HERE
    
    
    
    Welcome to Dungeon Crawl!
    #{"- " * 20}
    
    Be kind to this poor dumb oldschool game. One or two words is all you need. 
    You will never need to type something like "Tickle the clown with a feather."
    That would look more like "use feather" or "tickle clown".
    #{"- " * 20}
    You can move with N,S,E,W or use ? for help.
    #{"- " * 20}
    
    You've finally made it throught the woods and to the hidden dungeon. 
    Taking a deep breath you step inside. 
    HERE
  end

  def help
    <<~HERE
    Help & Hints
    -------------
    * The goal is to find the gold, and get out of the dungeon safely, carrying as many things as you can find.
    * Entering 'i' will get you to your inventory.
    * Entering 'look' will tell you about the room you're in.
    * Enter a cardinal direction & you will try to move that way.
    * Key words like 'use' and 'take' will let you interact with items.
    * Encounters in the dungeon may want an item to let you pass, or they may want you to do something else.
    * If you get really stuck type hint and you will get a hint specific to the encounter you're facing.
    * Good luck and have fun! Entering '?' will get you back to this help text.
    ------------
    HERE
  end

  def current_room
   @map[@avatar.location[0]][@avatar.location[1]]
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
      @vatar.leave("win", "You manage to leave alive. Huzzah!")
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
    case first
      when "debug"
        puts Utility.debug(current_room, @avatar)
        return true
      when "teleport"
        Utility.teleport(second, third, @avatar)
      when "use"
        unless @avatar.has_item?(second)
          puts "Whoops! No #{second} in inventory."
          return false
        end        
        if current_room.enc.handle_command(cmdstr, @avatar)
          @avatar.remove_item(second)
          return true
        end 
      when "take"
        if move_item(second, current_room, @avatar)
          puts "You pick up the #{second}."
          return true
        else
          puts "Whoops! No #{second} here."
          return false
        end 
      when "drop"
        if move_item(second, @avatar, current_room)
          puts "You drop the #{second}."
          return true
        else
          puts "Whoops! No #{second} in inventory."
          return false
        end
      else
       tf, msg = current_room.enc.handle_command(cmdstr, @avatar)
        puts msg
        return tf
    end
  end
  
  def run
    puts intro
    Utility.teleport(*@map_start)
    look
    while true
      puts "- " * 20
      print "What's next? > "
      command = gets.chomp.downcase
      
      case command        
      when "?", "help"              then puts help
      when "hint"                   then puts current_room.enc.hint
      when "i", "inv", "inventory"  then check_inventory
      when "look", "look room"      then look
      when "quit", "exit"           then break
      when "north", "east", "south", "west", "n", "e", "s", "w" then go(command)
      else 
        if handle_command(command)
          look
        else
          puts "Trying to #{command} won't work here."
        end
      end
      
    end
    @avatar.leave("die", "You die in the maze! Bye, Felicia!")
  end
  
end

Application.new.run
