def class Item
  def initialize(name:, type: "stackable", quantity: 1, equipped: false)
    @name = name
    @type = type
    @quantity = quantity
    @equipped = equipped
  end


end