def class Room
  def initialize(room_id: nil, doors: nil, encounter: nil, inventory: nil, description: nil)
    @room_id = room_id   
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
  
  def remove_item(item)
    @inventory.delete(item)
  end
  
  def replace_enc(new_enc)
    raise "Must be an encounter" unless new_enc.kind_of? NoEnc # NoEnc is base class
    @enc = new_enc    
  end
  
  def to_h
    {
      doors: @doors.map do |k, v|
        {direction: k,
        destination: v.to_h}
      end  
      description: @description,
      inventory: @inventory,
      enc: @enc.to_h
    }
  end
  
  def save_state
    {
      inventory: @inventory,
      enc: @enc.save_state
    }
  end
end