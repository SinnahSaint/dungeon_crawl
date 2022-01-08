class Avatar
  attr_reader :inventory

  def initialize(inv_hash)
    @inventory = Inventory.new(:loot => inv_hash[:loot], 
                               :equipment => inv_hash[:equipment],
                              )
  end

  def check_inventory
    items = @inventory.list(@inventory.loot)
    gear = @inventory.list(@inventory.equipment)

    unless items.empty?
      words1 = "Your inventory includes #{Utility.english_list(items) }"
    else
      words1 = "You're not carrying anything"
    end

    unless gear.empty?
      words3 = "you have #{Utility.english_list(gear)} equipped."
    else
      words3 = "you do not have anything equiped."
    end

    if words1 = "You're not carrying anything, " && words3 = "you do not have anything equiped."
      words2 = " and, "
    else
      words2 = " but, "
    end

    words1+words2+words3
  end

  def has_item?(item_name)
    !@inventory.find_item_index_by_name(item_name).nil?
  end

  def has_weapon
    @inventory.current_weapon
  end

  def equip(item)
    @inventory.equip_item(item)
  end

  def unequip(info)
    @inventory.unequip(info)
  end

  def to_h
    {
      inventory: @inventory.to_h
    }
  end

end