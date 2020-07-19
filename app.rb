require_relative "./player"

class Application
  
  def initialize
    @user = Player.new
    # layouts
    # encouinters
    # map
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
