require_relative "./player"
require_relative "./template"
require_relative "./room"
Dir["./encounters/*.rb"].each do |file_name|
  require_relative file_name
end



class Application
  
  def initialize
    @user = Player.new
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
      a: Template.new(encounter: ->{Avalanche.new}, inventory:["sturdy pole", "shiny pebble"], description: "room full of rubble"),
      c: Template.new(encounter: ->{Cow.new}, description: "mostly empty room with straw on the floor"),
      i: Template.new(encounter: ->{Ice.new}, description: "this room is really cold for no good reason"),
      j: Template.new(encounter: ->{Jester.new}, description: "a throne room with no one on the throne"),
      f: Template.new(encounter: ->{Fire.new}, description: "kitchen with a nice table"),
      g: Template.new(inventory:["gold"], description: "A lovely room filled with gold"),
      n: Template.new(description: "literally boring nothing room"),
    }

    @map = [
      [Room.new(@lay[:es], @temp[:f]), Room.new(@lay[:esw], @temp[:n]), Room.new(@lay[:w], @temp[:a])],
      [Room.new(@lay[:ns], @temp[:n]), Room.new(@lay[:n], @temp[:g]),   Room.new(@lay[:s], @temp[:c])],
      [Room.new(@lay[:ne], @temp[:j]), Room.new(@lay[:esw], @temp[:n]), Room.new(@lay[:nw], @temp[:a])],
    ]
    
  end
  
  def start_up
    look
    user_input 
  end
  
  def inventory
    puts "You have no pockets yet."
  end


  def help
    puts "There's no help yet."
  end

  def leave
    puts "You manage to leave alive. Huzzah!"
    inventory
    exit(0)
  end

  def description
    puts "Dank spooky room."
    #this will be comming from the room
  end

  def directions
    puts "You can only leave the way you came."
    #this will be comming from the room
  end

  def encounter
    puts "There's nothing interesting here."
    #this will be comming from the room
  end

  def room_inventory
    puts "Seriously, not even dust."
    #this will be comming form the room too
  end

  def go(nsew)
    if nsew == @user.back
      leave
    else
      puts "That's a wall dummy."
    end
  
  end

  def look
    description
    directions
    encounter
    room_inventory
    user_input
  end


  def user_input
    while true
      puts "What's next?"
      command = gets.chomp.downcase
  
      # this will filter ? and i but then send to the room which will check for direction
      # if not direction or inventory grab room will send to encounter
      # encounter will compare to known commands and if all this turns up nothing
      # user will be called an idiot and returned to input
      
      case command
      when "?"      then help
      when "i"      then inventory
      when "look"   then look
      when "north","east","south","west" then go(command)
      else
        puts "What are you talking about?"
        look
      end 
    
    end
  end
  
end


Application.new.start_up
