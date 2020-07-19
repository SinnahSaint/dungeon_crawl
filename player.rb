class Player
  attr_accessor :back, :inventory, :location
  
  def initialize
    @inventory = []
    @back = "south"
    @location = [2,1]      
  end
  
end