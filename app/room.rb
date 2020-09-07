class Room
  attr_reader :lay, :inventory, :enc, :description
  
  def ==(other)
    return false unless other.is_a?(Room)
    return false unless @description == other.description
    return false unless @inventory.sort == other.inventory.sort
    return false unless @lay == other.lay
    return false unless @enc == other.enc
    true
  end
  
  def initialize(layout: nil, encounter: nil, inventory: nil, description: nil)
    @lay = layout || %w[north east south west]
    @enc = encounter || NoEnc.new
    @inventory = inventory&.dup || []
    @description = description || ""
  end
  
  def remove_item(item)
    @inventory.delete(item)
  end
  
  def to_h
    {
      lay: @lay,
      description: @description,
      inventory: @inventory,
      enc: @enc.to_h
    }
  end
  
end
