class Room
  
  def initialize(lay, temp)
    @lay = lay
    @temp = temp
    @enc = temp.build_encounter
    @inv = temp.inv.dup
  end
  
  def description
    @temp.des
  end
  
  #need to fix this function
  def handle_command(cmdstr)
    if NSEW?
      return doNSEW
    else
      return @enc.handle_command(cmdstr)
    end
  end
  
end
