class NoEnc
    attr_reader :blocking
    
  def initialize
    @blocking = false
  end
  def handle_command(cmdstr)
    return false
  end
  def state
    ""
  end
end
