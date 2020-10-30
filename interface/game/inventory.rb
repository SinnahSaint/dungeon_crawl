def class Inventory
  attr_accessor :loot, :equipment

  def initialize(loot:, equipment:)
    @loot = loot || []
    @equipment = {head:,torso:,feet:,weapon:,trinket:,mood:,}.merge(equipment)
  end

  def add_item(name:, type:"stackable",)
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
    slot = gear[type]

    @equipment.merge{ slot => gear }

    remove_item(item_name)
  end

  def unequip_item(item_name)

  end

  def to_h
    {
    loot: @loot,
    equipment: @equipment
    }
  end

end