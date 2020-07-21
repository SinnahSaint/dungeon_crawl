class Cow
  attr_reader :blocking, :inventory

  def initialize
    @milked = false
    @has_milk = true
    @blocking = false
  end
  
  def remove_item(item)
    @inventory.delete(item)
  end

  def milk_bessy(avatar)
    if @has_milk && !@milked
      puts "You get some milk."
      @milked = true
      avatar.inventory << "milk"
      return true
    elsif @has_milk && @milked
      puts "You get the rest of the milk."
      @has_milk = false
      avatar.inventory << "milk"
      return true
    else
      puts "Bessy is not going to let you near her again today."
      return true
    end
  end
  
  def handle_command(cmdstr, avatar)
    if cmdstr == "milk cow" || cmdstr == "milk"
      milk_bessy(avatar)
    else
      puts "Bessy looks at you oddly."
      return false 
    end
  end
  
  def hint
    "Cows produce a LOT of milk each day."
  end
  
  def state
    if @has_milk 
      "There is a cow standing by a milking stool. She looks really uncomfortable."
    else
      "The cow is happy."
    end
  end
  
end
