class Killer
  attr_reader :blocking

  def initialize
    @blocking = true
    @dead = false
    @friend = false
  end
  
  def handle_command(cmdstr)
    if cmdstr == "use knife"
      @blocking = false
      @dead = true
      return true
    elsif cmdstr == "tell joke"
      puts "You died of being a smartass."
      exit(0)
    elsif cmdstr == "use milk"
      @blocking = false
      @friend = true
      return true
    else
      return false
    end
  end
  
  def state
    if @dead
      "OMG you actually killed him!"
    elsif @friend
      "Johny really appreciated the snack."
    else
      "This tough guy doesn't look like the type who laughs."
    end
  end
  
end