class Room
  attr_reader :lay, :inventory
  
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
  
  def enc
    @enc.description
  end

  def take()
    ""
  end
  
  
end

