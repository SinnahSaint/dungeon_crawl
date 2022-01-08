require_relative "./no_enc"

class Fire < NoEnc

  def initialize(blocking: true)
    super(blocking: blocking)
  end

  def handle_command(cmdstr, avatar)
    if cmdstr == "douse fire" || cmdstr == "use milk"
      if avatar.has_item?("milk")
        @blocking = false
        avatar.inventory.remove_item("milk")
        "The fire dies down."
      else
        "Whoops! No milk in inventory. "
      end  
    else
      false
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
