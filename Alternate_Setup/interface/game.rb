class Game
  def initialize(avatar:,map:,ui:)
    @avatar = avatar
    @map = map
    @ui = ui
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
    door = Door.new(destination: location, description: "~ ~ BAMPF! ~ ~")
    @ui.output(door.description)
    @map.follow_door(door)
  end

  def attempt_to_walk(direction)
    if @map.blocked?(direction)
      @ui.output "You'll have to deal with this first."
      return
    end

    door = @map.get_door(direction)
    if door.nil?
      @ui.output "That's a wall, dummy!"
      return
    end

    @ui.output(door.description)
    @map.follow_door(door)
  end

  def hint
  end

  def check_avatar_inventory
  end

  def check_room_inventory
  end

  def move_item(item, from, to, on_success: nil, on_fail: nil)
    on_fail ||= "Missing item #{item}"
    raise on_fail unless from.inventory.has?(item)
    
    from.remove_item(item)
    to.inventory << item
    
    on_success || "Moved #{item}"
  end

  def check_with_encounter(cmdstr)
  end

  def run
    @ui.output "Heyyyyyy"
  end



end