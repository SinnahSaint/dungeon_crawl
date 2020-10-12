class Avatar
  def initialize(inventory: nil)
    @inventory = Inventory.new(inventory || [])
  end


end