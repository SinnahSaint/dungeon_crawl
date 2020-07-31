class Avalanche < NoEnc
  
  def handle_command(cmdstr, avatar)
    if cmdstr == "yodel"
      @blocking = true
      "Rocks fall; You almost die. That was too daring."
    else
      ""
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
