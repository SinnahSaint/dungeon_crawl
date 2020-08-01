class Ice < NoEnc

  def handle_command(cmdstr, avatar)
    if cmdstr == "run" || cmdstr == "hurry" || cmdstr == "rush"
      avatar.leave("die", "You slip and fall cracking your head open. I told you it was slippery.")
    else
      false
    end
  end
  
  def hint
    "If you try to hurry, you might slip on ice."
  end
  
  def state
    "The floor is super slippery in here."
  end
  
end
