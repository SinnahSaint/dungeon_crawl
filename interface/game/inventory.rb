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

  def list(loot_or_equip)
    list = []

    if loot_or_equip == @loot
      @loot.each do |item|
        list << item.name
      end
    else
      @equipment.values.each do |item|
        list << item.name
      end
    end

    list
  end

  def add_item(item)
    @loot << item
  end

  def add_new_item(name:, type:"stackable")
    @loot << Item.new(name: name, type: type,)
  end

  def remove_item(item_name)
    location = find_item_index_by_name(item_name)
    if location == nil
      return "No such item in inventory."
    else
      @loot.delete_at(location)
    end
  end

  def current_weapon
    weapon = @equipment[:weapon] || Item.new(name: "none")
    weapon.name
  end

  def equip_item(item_name)
    gear = @loot.at(find_item_index_by_name(item_name))
    if gear.equipable?
      slot = gear.type
      @equipment[slot.to_sym] = gear
      remove_item(item_name)
    else
      "That item is not equipable."
    end
  end

  def unequip(info)
    @equipment.each{|slot,gear|
      if slot == info || gear.name == info
        unequip_by_slot(slot)
      else
        "#{info} is not equipped"
      end}
  end

  def unequip_by_slot(slot)
    gear = equipment[slot]
    add_item(gear)
    @equipment[slot] = nil
  end

  def find_item_index_by_name(item_name)
    @loot.find_index { |item| item.name == item_name }
  end

  def to_h
    {
    loot: @loot,
    equipment: @equipment
    }
  end

end
