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
      a: Template.new(encounter: ->{Avalanche.new}, inventory:["pole", "pebble"], description: "dusty room full of rubble"),
      c: Template.new(encounter: ->{Cow.new}, description: "mostly empty room with straw on the floor"),
      i: Template.new(encounter: ->{Ice.new}, description: "this room is really cold for no good reason"),
      j: Template.new(encounter: ->{Jester.new}, description: "a throne room with no one on the throne"),
      f: Template.new(encounter: ->{Fire.new}, inventory: ["knife"], description: "kitchen with a nice table"),
      g: Template.new(inventory:["gold"], description: "A lovely room filled with gold"),
      n: Template.new(description: "literally boring nothing room"),
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
    
  
  def start_up
    look
    user_input 
  end
  
  def inventory
    puts "Your inventory includes:"
    @avatar.inventory.each { |n| puts " * #{n}" }
  end


  def help
    puts "There's no help yet."
  end

  def leave
    puts "You manage to leave alive. Huzzah!"
    inventory
    exit(0)
  end

  def go(nesw)

    ### check against back
    #        ### if not back check room.enc for block
    ### if not block check against room.lay doors
    ### if allowed adjust location based on direction
    ### if not allowed, wall error   
     
    case nesw
    when @avatar.back then change_room(nesw)
    when current_room.enc.blocking then puts "You'll have to deal with this or go back."
    when *current_room.lay  then change_room(nesw)
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
    puts "There are exits to the #{Utility.english_list(current_room.lay)}"
    puts current_room.enc.state
    puts current_room.inventory
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
    while true
      puts "What's next?"
      command = gets.chomp.downcase
      
      case command
      when "?"      then help
      when "i"      then inventory
      when "look"   then look
      when "quit"   then break
      when "north","east","south","west" then go(command)
      else handle_command(command)
      end
    end
    puts "You die in the maze! Bye, Felicia!"
  end
  
end


Application.new.start_up
