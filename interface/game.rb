class Game
  attr_reader :avatar

  def initialize(avatar:,map:,ui:)
    @avatar = avatar
    @map = map
    @ui = ui
  end

  def equip(item)
    @avatar.equip(item)
  end
  
  def unequip(info)
    @avatar.unequip(info)
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
      @ui.output "You don't see any way to get through in that direction."
      return
    end

    @ui.output(door.description)
    @map.follow_door(door)
  end

  def hint
  end

  def check_avatar_inventory
   @ui.output @avatar.check_inventory
  end

  def check_room_inventory
    if current_room.inventory.loot.empty?
      " There's nothing you can take here."
    else
    " You can see " + Utility.english_list(current_room.inventory.loot) +
    "\n" + "- "*20 + "\n" + "What's next? > "
    end
  end

  def current_room
    @map.current_room
  end

  def move_item(item, from, to, on_success: nil, on_fail: nil)
    on_fail ||= "Missing item #{item}"
    raise on_fail unless from.inventory.include?(item)
    
    from.remove_item(item)
    to.inventory << item
    
    on_success || "Moved #{item}"
  end

  def check_with_encounter(cmdstr)
  end

  def prompt
    @map.current_description + check_room_inventory
  end

  def run
    @map.text
  end



end