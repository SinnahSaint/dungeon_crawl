class Fire
    attr_reader :blocking
  
  def initialize
    @blocking = true
  end
  
  def handle_command(cmdstr, avatar)
    if cmdstr == "douse fire" || cmdstr == "use milk"
      @blocking = false
      avatar.remove_item("milk")
      [true, "The fire dies down."]
    else
      [false, ""]
    end
  end
  
  def hint
    "Liquids are often used to put out fires."
  end
  
  def state
    if @blocking
      "OMG the table's on fire!"
    else
      "The table is singed where it used to be on fire."
    end
  end
  
end
