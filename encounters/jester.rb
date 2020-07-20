class Jester
    attr_reader :blocking
  
  def initialize
    @blocking = false
    @joke = false
  end
  
  def handle_command(cmdstr)
    if cmdstr == "tell joke"
      @joke = true
      return true
    else
      return false
    end
  end
  
  def state
    if @joke
      "Pleased with your wit, the jester has wandered away."
    else
      "The jester peaks around the throne asking for a joke."
    end
  end
  
end