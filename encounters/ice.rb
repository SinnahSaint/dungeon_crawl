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
  
  def hint
    "If you try to hurry, you might slip on ice."
  end
  
  def state
    "The floor is super slippery in here."
  end
  
end
