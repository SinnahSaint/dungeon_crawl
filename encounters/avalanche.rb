class Avalanche
  attr_reader :blocking
  
  def initialize
    @heldup = true
    @blocking = false
  end
  
  def handle_command(cmdstr)
    if cmdstr == "take pole"
      @heldup = false
      @Application.player.inventory += ["pole"]
      return true
    else
      return false
    end
  end
  
  def state
    if @heldup
      "There's a huge pile of rocks with a pole stuck in it."
    else
      "The rocks have fallen and there is no path here."
    end
  end
  
end