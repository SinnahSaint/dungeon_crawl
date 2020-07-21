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
      avatar.remove_item("knife")
      return [true, "He was not expecting that. The battle is short."]
    elsif cmdstr == "tell joke"
      avatar.leave("die", "You pissed him off and died of being a smartass.")
    elsif cmdstr == "use penny" || cmdstr == "give penny" 
      return [true, "He's insulted that you tried to bribe him."]
    elsif cmdstr == "use milk" || cmdstr == "give milk"
      @blocking = false
      @friend = true
      avatar.remove_item("milk")
      return [true, "That's just what he was looking for. You've made a friend."]
    else
      return false
    end
  end
  
  def hint
    "Friend or foe? That's up to you."
  end
  
  def state
    if @dead
      "The man lies dead on the floor. I can't beleve you actually killed him!"
    elsif @friend
      "Tommy waves at you from the table. He really appreciated the milk."
    else
      "In the room you see a man in leather armour. His sword is at his side. This guy doesn't look like the type who laughs easily. He looks at you and asks if you have something for him."
    end
  end
  
end