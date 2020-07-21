class Jester
    attr_reader :blocking
  
  def initialize
    @blocking = false
    @joke = false
  end
  
  def handle_command(cmdstr, avatar)
    if cmdstr == "tell joke"
      @joke = true
      puts "Pleased with your wit, the jester wanders away."
      avatar.inventory << "laughter" 
      return true
    else
      return false
    end
  end
  
  def hint
    puts "Just give him what he wants."
  end
  
  def state
    unless @joke
      "The jester peeks around the throne asking you to tell a joke."
    end
  end
  
end
