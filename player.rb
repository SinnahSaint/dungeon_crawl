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
    index = @inventory.index(item)
    @inventory.delete(index)
  end
  
  def leave(condition, msg)
    # merge of win and die
    if condition == "win"
      puts "You Win! #{msg}" 
      check_inventory
      exit(0)
    else
      puts msg + "\n Game Over!"
      exit(0)
    end
  end
  
end
