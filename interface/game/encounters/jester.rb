class Jester < NoEnc

  def initialize(blocking: true)
    super(blocking: blocking)
  end

  def handle_command(cmdstr, avatar)
    case cmdstr
    when "tell joke"
      @blocking = false
      avatar.inventory.add_new_item(name: "laughter", type: "mood") 
      "Pleased with your wit, the jester sits to whittle a flute."
    when "use knife", "stab jester",  "kill jester", "knife jester"
      if avatar.has_item?("knife")
        @blocking = false
        avatar.inventory.remove_item("laughter")
        avatar.inventory.remove_item("hope")
        avatar.inventory.remove_item("smile")
        "He was not expecting that. The battle is short."
      else
        "Whoops! No knife in inventory. "
      end   
    else
      false
    end
  end
  
  def hint
    "Just give him what he wants."
  end
  
  def state
    if @blocking == true
      "The jester peeks around the throne asking you to tell a joke."
    else
      ""
    end
  end
  
end
