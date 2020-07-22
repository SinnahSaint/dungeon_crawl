class NoEnc
    attr_reader :blocking
    
  def initialize
    @blocking = false
  end
  
  def handle_command(cmdstr, avatar)
    [false, ""]
  end
  
  def hint
    "No seriously. There's no encounter here."
  end
  
  def state
    ""
  end
  
end
