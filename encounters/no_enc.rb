class NoEnc
    attr_reader :blocking
    
  def initialize
    @blocking = false
  end
  
  def ==(other)
    return false unless self.class == other.class
    return false unless @blocking == other.blocking
    return false unless state == other.state
    true
  end
  
  def handle_command(cmdstr, avatar)
    false
  end
  
  def hint
    "No seriously. There's no encounter here."
  end
  
  def state
    ""
  end
  
  def to_h
    {
      class: self.class.name,
      blocking: @blocking,
    }
  end
  
end
