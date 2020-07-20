class Fire
  def initialize
    @raging = true
  end
  def handle_command(cmdstr)
    if cmdstr == "douse fire"
      @raging = false
      return true
    else
      return false
    end
  end
  def state
    if @raging
      "OMG the tables on fire"
    else
      "The table used to be on fire, phew."
    end
  end
end