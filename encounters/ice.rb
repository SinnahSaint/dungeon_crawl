class Ice
    attr_reader :blocking
  
  def initialize
    @blocking = false
  end
  
  def handle_command(cmdstr)
    return false
  end
  
  def state
    "The floor is super slippery in here."
  end
  
end