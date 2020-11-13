class Killer < NoEnc
  
  def initialize(blocking: true, dead: false, friend: false)
    super(blocking: blocking)
    @dead = dead
    @friend = friend
  end
  
  def handle_command(cmdstr, avatar)   
    missing_item = "Whoops! You don't seem to have the item to do that in your inventory. " 
    
    case cmdstr
    when "use knife", "stab man",  "kill man", "knife man"
      if avatar.has_weapon == "knife"
        @blocking = false
        @dead = true
        avatar.inventory.remove_item("laughter")
        avatar.inventory.remove_item("hope")
        avatar.inventory.remove_item("smile")
        "He was not expecting that. The battle is short."
      else
        missing_item
      end   
    when "tell joke"
      avatar.leave("You pissed him off and died in the bowels of the dungeon. Game Over!")
    when "use penny", "give penny"
      if avatar.has_item?("penny")
        avatar.inventory.remove_item("smile")
        @friend = false
        "He's insulted and doesn't look very friendly."
      else
        missing_item
      end  
    when "use gold", "give gold", "use gemstone", "give gemstone"  
      if avatar.has_item?("gold")
        "He's insulted that you tried to bribe him with his own treasure."
        avatar.leave("You pissed him off and died in the bowels of the dungeon. Game Over!")
      else
        missing_item
      end
    when "use milk", "give milk"
      if avatar.has_item?("milk")
        @blocking = false
        @friend = true
        avatar.inventory.remove_item("milk")
        avatar.inventory.add_new_item(name: "smile", type: "mood")
        "That's just what he was looking for. You've made a friend."
      else
        missing_item
      end
    when "hug man", "give hug", "give kiss", "kiss man" 
      @blocking = false
      @friend = true
      avatar.inventory.add_new_item(name: "smile", type: "mood")
      "He was not expecting that. You've made a friend." 
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
      "Tommy waves at you from the table. He trusts you now."
    else
      <<~HERE
      In the room you see a man in leather armour. His sword is at his side. This guy 
      doesn't look like the type who laughs easily. He looks at you and asks if you 
      have something for him.
      HERE
    end
  end
  
  def to_h    
    super.deep_merge(params: {
      dead: @dead,
      friend: @friend,
    })
  end
  
end