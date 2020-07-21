class Player
  attr_accessor :back, :inventory, :location
  
  def initialize
    @inventory = %w[lint penny hope]
    @back = ""
    @location = [3,1]      
  end
  
  def has_item?(item)
    @inventory.include?(item)
  end
  
  def remove_item(item)
    index = @inventory.index(item)
    @inventory.delete(index)
  end
  
end
