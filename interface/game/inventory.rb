class Inventory

  attr_accessor :loot, :equipment

  def initialize(loot:, equipment:)
    @loot = loot || []
    @equipment = {
      head: nil, 
      torso: nil, 
      feet: nil, 
      weapon: nil, 
      trinket: nil, 
      mood: nil, 
      }.merge(equipment)
  end

  def add_item(name: nil, type:"stackable")
    @loot << Item.new(name: name, type: type,)
  end

  def find_item_index_by_name(item_name)
    @loot.find_at { |item| item.name == item_name }
  end


  def remove_item(item_name)
    @loot.delete_at(find_item_index_by_name(item_name))
  end

  def equip_item(item_name)
    gear = find_item_index_by_name(item_name)
    slot = gear.type
 
    @equipment[slot.to_sym] = gear

    remove_item(item_name)
  end

  def unequip_item(slot)
    gear = equipment[slot]
    @loot<<gear
    @equipment[slot] = nil
  end

  def to_h
    {
    loot: @loot,
    equipment: @equipment
    }
  end

end