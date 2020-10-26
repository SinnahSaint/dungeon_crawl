class Avatar
  attr_reader :inventory
  def initialize(inventory: nil)
    @inventory = inventory&.dup || []
  end

  def to_h
    {
      inventory: @inventory
    }
  end

end