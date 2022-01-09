require "./interface/game/inventory.rb"
require "./interface/game/door.rb"

class Room
  attr_reader :doors, :enc, :inventory, :description
  
  def initialize(doors: nil, encounter: nil, inventory: nil, description: nil)
    @doors = doors || {} 
    @enc = encounter || NoEnc.new
    inventory = inventory || {loot: [], equipment: {}}
    @inventory = Inventory.new(loot: inventory[:loot], 
                               equipment: inventory[:equipment],
                              )
    @description = description || ""
  end
  
  def ==(other)
    return false unless other.is_a?(Room)
    return false unless @description == other.description
    return false unless @inventory.loot.sort == other.inventory.loot.sort
    return false unless @inventory.equipment == other.inventory.equipment
    return false unless @doors == other.doors
    return false unless @enc == other.enc
    true
  end

  def blocked?
    @enc.blocking
  end
  
  def remove_item(item)
    @inventory.delete(item)
  end
  
  def replace_enc(new_enc)
    raise "Must be an encounter" unless new_enc.kind_of? NoEnc # NoEnc is base class
    @enc = new_enc    
  end
  
  def to_h
    {  
      description: @description,
      inventory: @inventory.to_h,
      encounter: @enc.to_h,
      doors: @doors.transform_values(&:to_h),  #short form
    }
  end
end

# doors: @doors.transform_values do |door|  #same thing but longer
#   door.to_h
# end
