require 'test/unit'
require 'ostruct'
require_relative '../room.rb'

class RoomTest < Test::Unit::TestCase
  def setup
  @template = OpenStruct.new({
    build_encounter: "encounter built", 
    description: "template description",
    inventory: %w[item another],
  })
  
  @room = Room.new("layout", @template)
  end

  def test_room_creation    
    assert_equal @room.lay, "layout"
    assert_equal @room.enc, "encounter built"
    assert_equal @room.inventory, %w[item another]
  end
  
  
  def test_room_description
    assert_equal @room.description, "template description"
  end


  def test_item_delete
    @room.remove_item("item")
    assert_not_equal @room.inventory, @template.inventory
  end

  # def teardown
  # end  
end