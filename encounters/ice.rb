class Ice
    attr_reader :blocking
  
  def initialize
    @blocking = false
  end
  
  def handle_command(cmdstr, avatar)
    if cmdstr == "run" || cmdstr == "hurry"
      puts "You slip and fall cracking your head open. I told you it was slippery."
      exit(0)
    else
    end
    return false
  end
  
  def state
    "The floor is super slippery in here. Maybe don't hurry."
  end
  
end
