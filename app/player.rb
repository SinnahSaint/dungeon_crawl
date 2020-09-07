class Player
  attr_accessor :back, :inventory, :location
  
  def initialize(game)
    @inventory = %w[lint penny hope]
    @back = ""
    @location = [] 
    @game = game    
  end
  
  def has_item?(item)
    @inventory.include?(item)
  end
  
  def remove_item(item)
    if has_item?(item)
      index = @inventory.index(item)
      @inventory.delete_at(index)
    end
  end
  
  def leave(msg)
      @game.game_over(msg)
  end
  
  def to_h
    {
      back: @back,
      location: @location,
      inventory: @inventory,
    }
  end
  
end
