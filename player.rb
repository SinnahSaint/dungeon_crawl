class Player
  attr_accessor :back, :inventory, :location
  
  def initialize
    @inventory = %w[lint penny hope]
    @back = ""
    @location = []      
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
  
  def leave(condition, reward)
    if condition == "win"
      puts "You Win!\nYou manage to leave alive. Huzzah!\n #{reward}" 
      exit(0)
    else
      puts reward + "\n Game Over!"
      exit(0)
    end
  end
  
end
