class Avalanche
  attr_reader :blocking
  
  def initialize
    @heldup = true
    @blocking = false
  end
  
  def handle_command(cmdstr, avatar)
    
    if cmdstr == "yodel"
      @heldup = false
      @blocking = true
      puts "Rocks fall; You almost die."
      return true
    else
      return false
    end
  end
  
  def state
    if @heldup
      "There's a huge pile of rocks. It kind of reminds you of the Alpine Mountains."
    else
      "The rocks have fallen and there is no path here."
    end
  end
  
end