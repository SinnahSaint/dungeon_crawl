class Avatar
  attr_reader :inventory

  def initialize(inventory:)
    @inventory = Inventory.new(
                                loot: inventory[loot], 
                                equipment: inventory[equipment],
                              )
  end

  def to_h
    {
      inventory: @inventory.to_h
    }
  end

end