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
  
  def initialize(lay, temp)
    @lay = lay
    @description = temp.description
    @enc = temp.build_encounter
    @inventory = temp.inventory.dup
  end
  
  def remove_item(item)
    @inventory.delete(item)
  end
  
end
