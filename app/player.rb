class Player
  attr_reader :back, :inventory, :location
  
  def initialize(game)
    @inventory = %w[lint penny hope]
    @back = ""
    @location = nil 
    @game = game    
  end
  
  def move(location, back)
    @location = location
    @back = back
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
      location: @location.to_h,
      inventory: @inventory,
    }
  end
  
end
