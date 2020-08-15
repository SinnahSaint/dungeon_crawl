class Killer < NoEnc
  
  def initialize
    super
    @blocking = true
    @dead = false
    @friend = false
  end
  
  def handle_command(cmdstr, avatar)
    
    ## Add hug option so you can keep milk
    
    case cmdstr
    when "use knife", "stab man",  "kill man", "knife man"
      if avatar.has_item?("knife")
        @blocking = false
        @dead = true
        avatar.remove_item("laughter")
        avatar.remove_item("hope")
        avatar.remove_item("smile")
        "He was not expecting that. The battle is short."
      else
        "Whoops! No knife in inventory. "
      end   
    when "tell joke"
      avatar.leave("You pissed him off and died of being a smartass.")
    when "use penny", "give penny", "use gold", "give gold" 
      if avatar.has_item?("penny")
        avatar.remove_item("smile")
        "He's insulted that you tried to bribe him."
      else
        "Whoops! No penny in inventory. "
      end  
      if avatar.has_item?("gold")
        "He's insulted that you tried to bribe him with his own gold."
        avatar.leave("You pissed him off and died in the bowels of the dungeon.")
      else
        "Whoops! No gold in inventory. "
      end
    when "use milk", "give milk"
      if avatar.has_item?("milk")
        @blocking = false
        @friend = true
        avatar.remove_item("milk")
        avatar.inventory << "smile"
        "That's just what he was looking for. You've made a friend."
      else
        "Whoops! No milk in inventory. "
      end  
    else
      false
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
      <<~HERE
      In the room you see a man in leather armour. His sword is at his side. This guy 
      doesn't look like the type who laughs easily. He looks at you and asks if you 
      have something for him.
      HERE
    end
  end
  
  def to_h    
    super.merge({
      dead: @dead,
      friend: @friend,
    })
  end
  
end