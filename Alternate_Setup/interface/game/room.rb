class Room
  def initialize(doors: nil, encounter: nil, inventory: nil, description: nil)
    @doors = doors || {}
    @enc = encounter || NoEnc.new
    @inventory = inventory&.dup || []
    @description = description || ""
  end
  
  def ==(other)
    return false unless other.is_a?(Room)
    return false unless @description == other.description
    return false unless @inventory.sort == other.inventory.sort
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
      inventory: @inventory,
      encounter: @enc.to_h
      doors: @doors.transform_values(&:to_h)  #short form
    }
  end
end

# doors: @doors.transform_values do |door|  #same thing but longer
#   door.to_h
# end
