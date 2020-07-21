class Jester
    attr_reader :blocking
  
  def initialize
    @blocking = false
    @joke = false
  end
  
  def handle_command(cmdstr, avatar)
    if cmdstr == "tell joke"
      @joke = true
      avatar.inventory << "laughter" 
      return [true, "Pleased with your wit, the jester wanders away."]
    else
      return false
    end
  end
  
  def hint
    "Just give him what he wants."
  end
  
  def state
    unless @joke
      "The jester peeks around the throne asking you to tell a joke."
    end
  end
  
end
