# useless til there's layouts and templates to pass in

class Room
  
  def initialize(lay[], temp[])
  
  #need to fix this function
  def handle_command(cmdstr)
    if NSEW?
      return doNSEW
    else
      return @enc.handle_command(cmdstr)
    end
  end

end