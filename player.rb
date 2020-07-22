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
    @inventory.delete_at(index)
  end
  
  def leave(condition, msg)
    # merge of win and die
    if condition == "win"
      puts "You Win!\n#{msg}\nHere's your loot:" 
      
      # it's not  @inventory.each or @avatar.inventory.each or self.inventory.each
      # it's definitely not inventory.each
      # passing in @avatar to avatar doesn't make avatar.inventory.each work
      avatar.inventory.each { |n| puts " * #{n}" }
      exit(0)
    else
      puts msg + "\n Game Over!"
      exit(0)
    end
  end
  
end
