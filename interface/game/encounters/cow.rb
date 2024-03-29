require_relative "./no_enc"

class Cow < NoEnc

  def initialize(blocking:false, milked: false, has_milk: true)
    super(blocking: blocking)    
    @milked = milked
    @has_milk = has_milk
  end

  def handle_command(cmdstr, avatar)
    case cmdstr 
    when "milk cow", "milk"
      milk_bessy(avatar)  
    when "use knife", "stab cow",  "kill cow", "knife cow"
      if avatar.has_item?("knife")
        avatar.inventory.remove_item("laughter")
        avatar.inventory.remove_item("hope")
        avatar.inventory.remove_item("smile")
        avatar.inventory.remove_item("milk")
        avatar.leave("She sees you comming and kicks you into next week. You die bleeding out on the rug. Game Over!")
      else
        "Whoops! No knife in inventory. "
      end   
    else
      false
    end
  end
  
  def hint
    "Cows produce a LOT of milk each day."
  end
  
  def state
    if @has_milk 
      "There is a cow looking at you. She looks really uncomfortable."
    else
      "The cow is happy."
    end
  end
    
  def milk_bessy(avatar)
    if @has_milk && !@milked
      @milked = true
      avatar.inventory.add_new_item(name: "milk")
      "You get some milk."
    elsif @has_milk && @milked
      @has_milk = false
      avatar.inventory.add_new_item(name: "milk")
      "You get the rest of the milk."
    else
      "Bessy is not going to let you near her again today."
    end
  end
  
  def to_h
    super.deep_merge(params: {
      milked: @milked,
      has_milk: @has_milk,
    })
  end  
end
