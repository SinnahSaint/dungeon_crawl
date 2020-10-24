class Inventory
  attr_accessor :items

  def initialize(items)
    @items = items || []
    # @equipped = equipped
  end

  def has?(item)
    @items.include?(item)
  end

  # def equipped?(item)
  #   @equipped.include(item)
  # end

  def ==(other)
    @items.sort == other.items.sort # && @equiped.sort == other.@equipped.sort
    ## when I get to equipping items
  end

  def to_h
    {
      inventory: @items.sort,
      # equipped: @equipped.sort
    }
  end

end