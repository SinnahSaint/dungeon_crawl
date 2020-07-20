class Fire
    attr_reader :blocking
  
  def initialize
    @blocking = true
  end
  
  def handle_command(cmdstr)
    if cmdstr == "douse fire"
      @blocking = false
      return true
    else
      return false
    end
  end
  
  def state
    if @blocking
      "OMG the tables on fire"
    else
      "The table used to be on fire, phew."
    end
  end
end