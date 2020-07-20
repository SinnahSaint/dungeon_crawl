
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
      "Cow looks really uncomfortable."
    else
      "Cow is happily without milk."
    end
  end
  
end