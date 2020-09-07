require 'test/unit'
require_relative '../app/room.rb'

class RoomTest < Test::Unit::TestCase
  def setup
    @initial_inventory = %w[item another]
    @room = Room.new(layout: nil, encounter: "encounter", description: "description", inventory: @initial_inventory,)
  end

  def test_room_creation    
    assert_equal @room.lay, %w[north east south west]
    assert_equal @room.enc, "encounter"
    assert_equal @room.inventory, @initial_inventory
    assert_equal @room.description, "description"
  end
  
  def test_add_item
    @room.inventory<<"more"
    assert @room.inventory.include?("more")
  end

  def test_item_delete
    
    @room.remove_item("item")
    assert_not_equal @room.inventory, @initial_inventory
  end 
end
