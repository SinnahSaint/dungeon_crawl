class Jester < NoEnc

  def initialize
    @joke = false
    super
  end

  def handle_command(cmdstr, avatar)
    if cmdstr == "tell joke"
      @joke = true
      avatar.inventory << "laughter" 
      "Pleased with your wit, the jester wanders away."
    else
      false
    end
  end
  
  def hint
    "Just give him what he wants."
  end
  
  def state
    if @joke == false
      "The jester peeks around the throne asking you to tell a joke."
    else
      ""
    end
  end
  
end
