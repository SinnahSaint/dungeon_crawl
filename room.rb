class Room
  attr_reader :lay, :inventory, :enc, :description
  
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
