def inventory
  puts "You have no pockets yet."
end


def help
  puts "There's no help yet."
end

def leave
  puts "You manage to leave alive. Huzzah!"
  puts inventory
  exit(0)
end

def description
  puts "dank spooky room"
  #this will be comming from the room
end

def directions
  puts "you can only leave the way you came"
  #this will be comming from the room
end

def encounter
  puts "there's nothing interesting here"
  #this will be comming from the room
end

def go(nsew)
  if nsew == "south"
    leave
  else
    puts "That's a wall dummy."
  end
end

def look
  puts description
  puts directions
  puts encounter
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

look
user_input