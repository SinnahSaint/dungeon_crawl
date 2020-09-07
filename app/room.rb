class Room
  attr_reader :lay, :inventory, :enc, :description
  
  LAY = {
    oob: [],
    n: %w[north],
    e: %w[east],
    s: %w[south],
    w: %w[west],
    ne: %w[north east],
    ns: %w[north south],
    nw: %w[north west],
    es: %w[east south],
    ew: %w[east west],
    sw: %w[south west],
    nes: %w[north east south],
    new: %w[north east west],
    nsw: %w[north south west],
    esw: %w[east south west],
    nesw: %w[north east south west],
  }.freeze
    
  def initialize(layout: nil, encounter: nil, inventory: nil, description: nil)    
    @lay = LAY.fetch(layout || :nesw) # will error if garbage input
    @enc = encounter || NoEnc.new
    @inventory = inventory&.dup || []
    @description = description || ""
  end
  
  def ==(other)
    return false unless other.is_a?(Room)
    return false unless @description == other.description
    return false unless @inventory.sort == other.inventory.sort
    return false unless @lay == other.lay
    return false unless @enc == other.enc
    true
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
