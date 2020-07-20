class Jester
    attr_reader :blocking
  
  def initialize
    @blocking = false
    @joke = false
  end
  
  def handle_command(cmdstr)
    if cmdstr == "tell joke"
      @joke = true
      puts "Pleased with your wit, the jester wanders away."
      return true
    else
      return false
    end
  end
  
  def state
    if @joke
      ""
    else
      "The jester peeks around the throne asking for a joke."
    end
  end
  
end
