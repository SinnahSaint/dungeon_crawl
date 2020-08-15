class NoEnc
    attr_reader :blocking, :inventory
    
  def initialize
    @blocking = false
    @inventory = []
  end
  
  def ==(other)
    return false unless self.class == other.class
    return false unless @blocking == other.blocking
    return false unless @inventory == other.inventory
    return false unless state == other.state
    true
  end
  
  def remove_item(item)
    @inventory.delete(item)
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
  
end
