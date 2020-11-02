class Avatar
  attr_reader :inventory

  def initialize(inv_hash)
    @inventory = Inventory.new({:loot => inv_hash[:loot], 
                                :equipment => inv_hash[:equipment],
                                })
  end

  def has_item?(item_name)
    !@inventory.find_item_index_by_name(item_name).nil?
  end

  def has_weapon
    @inventory.current_weapon
  end

  def to_h
    {
      inventory: @inventory.to_h
    }
  end

end