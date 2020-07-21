class Room
  attr_reader :lay, :inventory, :enc
  
  def initialize(lay, temp)
    @lay = lay
    @temp = temp
    @enc = temp.build_encounter
    @inventory = temp.inventory.dup
  end
  
  def description
    @temp.description
  end
  
  def remove_item(item)
    @inventory.delete(item)
  end
  
end
