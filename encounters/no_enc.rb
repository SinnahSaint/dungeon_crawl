class NoEnc
    attr_reader :blocking
    
  def initialize
    @blocking = false
    @inventory = []
  end
  
  def remove_item(item)
    @inventory.delete(item)
  end
  
  def handle_command(cmdstr, avatar)
    ""
  end
  
  def hint
    "No seriously. There's no encounter here."
  end
  
  def state
    ""
  end
  
end
