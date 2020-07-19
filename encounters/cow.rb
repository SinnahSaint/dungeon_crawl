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
      return false
    end
  end
  
  def description
    if @has_milk
      "Cow looks really uncomfortable."
    else
      "Cow is happily without milk."
    end
  end
  
end