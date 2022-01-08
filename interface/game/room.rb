require "./interface/game/inventory.rb"
require "./interface/game/door.rb"

class Room
  attr_reader :door_list, :enc, :inventory, :description
  
  def initialize(doors: nil, encounter: nil, inventory: nil, description: nil)
    @door_list = doors || {} 
    @enc = encounter || NoEnc.new
    inventory = inventory || {loot: [], equipment: {}}
    @inventory = Inventory.new(loot: inventory[:loot], 
                               equipment: inventory[:equipment],
                              )
    @description = description || ""
  end
  
  def ==(other)
    return false unless other.is_a?(Room)
    return false unless @room_desc == other.room_desc
    return false unless @room_inv.loot.sort == other.room_inv.loot.sort
    return false unless @room_inv.equipment == other.room_inv.equipment
    return false unless @door_list == other.door_list
    return false unless @enc == other.enc
    true
  end

  def blocked?
    @enc.blocking
  end
  
  def remove_item(item)
    @room_inv.delete(item)
  end
  
  def replace_enc(new_enc)
    raise "Must be an encounter" unless new_enc.kind_of? NoEnc # NoEnc is base class
    @enc = new_enc    
  end
  
  def to_h
    {  
      description: @room_desc,
      inventory: @room_inv.to_h,
      encounter: @enc.to_h,
      doors: @door_list.transform_values(&:to_h),  #short form
    }
  end
end

# doors: @doors.transform_values do |door|  #same thing but longer
#   door.to_h
# end
