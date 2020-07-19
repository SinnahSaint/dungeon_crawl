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
      a: Template.new(encounter: ->{Avalanche.new}, inventory:["sturdy pole", "shiny pebble"], description: "dusty room full of rubble"),
      c: Template.new(encounter: ->{Cow.new}, description: "mostly empty room with straw on the floor"),
      i: Template.new(encounter: ->{Ice.new}, description: "this room is really cold for no good reason"),
      j: Template.new(encounter: ->{Jester.new}, description: "a throne room with no one on the throne"),
      f: Template.new(encounter: ->{Fire.new}, inventory: ["sharp knife"], description: "kitchen with a nice table"),
      g: Template.new(inventory:["gold"], description: "A lovely room filled with gold"),
      n: Template.new(description: "literally boring nothing room"),
    }

    @map = [
      [Room.new(@lay[:es], @temp[:f]), Room.new(@lay[:esw], @temp[:n]), Room.new(@lay[:w], @temp[:a])],
      [Room.new(@lay[:ns], @temp[:n]), Room.new(@lay[:n], @temp[:g]),   Room.new(@lay[:s], @temp[:c])],
      [Room.new(@lay[:ne], @temp[:j]), Room.new(@lay[:esw], @temp[:n]), Room.new(@lay[:nw], @temp[:a])]
    ]
    
    @room = @map[@user.location[0]][@user.location[1]]
  end
  
  def start_up
    look
    user_input 
  end
  
  def inventory
    puts "Your inventory includes:"
    @user.inventory.each { |n| puts " * #{n}" }
  end


  def help
    puts "There's no help yet."
  end

  def leave
    puts "You manage to leave alive. Huzzah!"
    inventory
    exit(0)
  end





  def handle_command(input)
    
    case input
    when "north","east","south","west" then go(input)
    when "use"  then @user.use
    else
      @room.handle_command(cmdstr)
    end
    
  end




  def go(nesw)
    
  
    ### check against back
    ### if not back check room.enc for block
    ### if not block check against room.lay doors
    ### if allowed adjust location based on direction
    ### if not allowed, wall error
    
    
    if nesw == @user.back
      @user.location[0] += 1 
    else
      puts "That's a wall dummy."
    end
    
    case nesw
    when "north"  then  
    when "east"   then
    when "south"  then
    when "west"   then
    else
      @room.handle_command(cmdstr)
    end
    
    
    if @user.location[0] >= 3
      puts "User location is: #{@user.location}"
      leave
    else
      puts "still dungeon"
    end
  
  end








  def look
    puts @room.des
    puts @room.lay
    puts @room.enc
    puts @room.inv
    user_input
  end


  def user_input
    while true
      puts "What's next?"
      command = gets.chomp.downcase
  
      # this will filter "?" and "i" but then send to the room which will check for direction
      # if not direction or inventory grab room will send to encounter
      # encounter will compare to known commands and if all this turns up nothing
      # user will be called an idiot and returned to input
      
      case command
      when "?"      then help
      when "i"      then inventory
      when "look"   then look
      else 
        handle_command(command)
      end 
    
    end
  end
  
end


Application.new.start_up
