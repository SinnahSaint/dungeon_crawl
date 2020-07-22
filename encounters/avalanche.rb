class Avalanche
  attr_reader :blocking
  
  def initialize
    @blocking = false
  end
  
  def handle_command(cmdstr, avatar)
    if cmdstr == "yodel"
      @blocking = true
      [true, "Rocks fall; You almost die. That was almost too daring."]
    else
      [false, ""]
    end
  end
  
  def hint
   "If you're daring, a yodel might do something."
  end
  
  def state
    unless @blocking
      "There's a huge pile of rocks. It kind of reminds you of the Alpine Mountains."
    else
      "The rocks have fallen and there is no path here."
    end
  end
  
end
