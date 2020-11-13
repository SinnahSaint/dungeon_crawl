class Item
  attr_reader :name, :type
  
  def initialize(name:, type: "stackable")
    @name = name
    @type = type # equip slot like "head" or just "stackable"
  end

  def equipable?
    @type != "stackable"
  end

end