class Avatar
  def initialize(inventory: nil)
    @inventory = Inventory.new(inventory || [])
  end

  def to_h
    {
      inventory: @inventory
    }
  end

end