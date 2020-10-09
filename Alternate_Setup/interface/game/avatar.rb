class Avatar
  def initialize(location: nil, inventory: nil)
    @location = location
    @inventory = inventory || Inventory.new
  end


end