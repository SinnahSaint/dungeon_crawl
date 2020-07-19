class Player
  attr_accessor :back, :inventory, :location
  
  def initialize
    @inventory = %w[lint penny hope]
    @back = "south"
    @location = [2,1]      
  end
  
end
