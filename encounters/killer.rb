class Killer
  attr_reader :blocking

  def initialize
    @blocking = true
    @dead = false
    @friend = false
  end
  
  def handle_command(cmdstr, avatar)
    if cmdstr == "use knife" || cmdstr == "stab man" || cmdstr == "kill man"
      @blocking = false
      @dead = true
      avatar.remove_item(knife)
      return true
    elsif cmdstr == "tell joke"
      puts "You pissed him off and died of being a smartass."
      exit(0)
    elsif cmdstr == "use milk" || cmdstr == "give milk"
      @blocking = false
      @friend = true
      avatar.remove_item(milk)
      return true
    else
      return false
    end
  end
  
  def state
    if @dead
      "Tommy lies dead on the floor. I can't beleve you actually killed him!"
    elsif @friend
      "Tommy waves at you from the table. He really appreciated the milk."
    else
      "In the room you see a man in leather armour. His sword is at his side. This guy doesn't look like the type who laughs easily. He looks at you and asks if you have something for him."
    end
  end
  
end