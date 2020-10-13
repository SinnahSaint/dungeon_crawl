class Game
  def initialize(avatar:,map:,)
    @avatar = avatar
    @map = map
  end

  def to_h
    {
      avatar: @avatar.to_h,
      map: @map.to_h,
    }
  end



  def debug
  end

  def debug_game
  end

  def teleport(location)
    @map.move(Door.new(destination: location, description: "~ ~ BAMPF! ~ ~") 
  end

  def attempt_to_walk(direction)
    
  end

  def hint
  end

  def check_avatar_inventory
  end

  def check_room_inventory
  end

  def move_item(item, from, to, on_success: nil, on_fail: nil)
    raise on_fail unless from.inventory.include?(item)
    on_fail ||= "Missing item #{item}"
    
    from.remove_item(item)
    to.inventory << item
    
    on_success || "Moved #{item}"
  end

  def check_with_encounter(cmdstr)
  end





end