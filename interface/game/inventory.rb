require "./interface/game/item.rb"

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

  def current_weapon
    weapon = @equipment[:weapon] || Item.new(name: "none")
    weapon.name
  end

  def add_item(name:, type:"stackable")
    @loot << Item.new(name: name, type: type,)
  end

  def find_item_index_by_name(item_name)
    @loot.find_index { |item| item.name == item_name }
  end

  def remove_item(item_name)
    location = find_item_index_by_name(item_name)
    if location == nil
      return "No such item in inventory."
    else
      @loot.delete_at(location)
    end
  end

  def equip_item(item_name)
    gear = @loot.at(find_item_index_by_name(item_name))
    if gear.equipable?
      slot = gear.type
      @equipment[slot.to_sym] = gear
      remove_item(item_name)
    else
      raise "That item is not equipable."
    end
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