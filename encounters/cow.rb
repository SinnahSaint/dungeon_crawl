class Cow < NoEnc

  def initialize
    @milked = false
    @has_milk = true
    super
  end

  def handle_command(cmdstr, avatar)
    if cmdstr == "milk cow" || cmdstr == "milk"
      milk_bessy(avatar)
    else
      false
    end
  end
  
  def hint
    "Cows produce a LOT of milk each day."
  end
  
  def state
    if @has_milk 
      "There is a cow in a milking stand. She looks really uncomfortable."
    else
      "The cow is happy."
    end
  end
    
  def milk_bessy(avatar)
    if @has_milk && !@milked
      @milked = true
      avatar.inventory << "milk"
      "You get some milk."
    elsif @has_milk && @milked
      @has_milk = false
      avatar.inventory << "milk"
      "You get the rest of the milk."
    else
      "Bessy is not going to let you near her again today."
    end
  end
  
end
