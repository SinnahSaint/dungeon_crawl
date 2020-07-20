class Cow
  #this is fire details, needs to be changed later
  def initialize
    @has_milk = true
  end
  
  def handle_command(cmdstr)
    if cmdstr == "milk cow"
      @has_milk = false
      # give player milk
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