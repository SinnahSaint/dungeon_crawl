class Cow
  attr_reader :blocking, :inventory

  def initialize
    @has_milk = true
    @blocking = false
  end
  
  def remove_item(item)
    @inventory.delete(item)
  end
  
  def handle_command(cmdstr, avatar)
    if cmdstr == "milk cow" || cmdstr == "milk"
      @has_milk = false
      avatar.inventory << "milk"
      return true
    else
      puts "Bessy looks at you oddly."
      return false
    end
  end
  
  def state
    if @has_milk
      "There is a cow standing by a milking stool. She looks really uncomfortable."
    else
      "The cow is happy."
    end
  end
  
end
