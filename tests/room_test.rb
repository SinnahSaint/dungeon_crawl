require 'test/unit'

require './interface/game/room.rb'
require "./interface/game/encounters/no_enc.rb"
require "./interface/game/encounters/fire.rb"

class RoomTest < Test::Unit::TestCase

  def setup
    @default = Room.new
    @custom = Room.new(
                    doors: { N: Door.new(destination:{x: 2, 
                                                      y: 3, 
                                                      back: "home"
                                                      }) }, 
                    encounter: Fire.new, 
                    inventory: {  loot: ["penny", "lint"], 
                                  equipment: { head:"helmet", mood: "hope" }
                                }, 
                    description: "This is a test room.")
  end

  def test_default_init
    assert @default.doors.instance_of?(Hash)
    assert @default.doors.empty?
    assert @default.enc.instance_of?(NoEnc) 
    assert @default.room_inv.instance_of?(Inventory)
    assert @default.room_inv.equipment.instance_of?(Hash)

    expected = {:feet=>nil, :head=>nil, :mood=>nil, :torso=>nil, :trinket=>nil, :weapon=>nil}
    assert_equal expected, @default.room_inv.equipment

    assert @default.room_inv.loot.instance_of?(Array)
    assert @default.room_inv.loot.empty?

    assert_equal "", @default.room_desc
  end

  def test_custom_init
    assert @custom.doors.instance_of?(Hash)
    assert @custom.doors[:N].instance_of?(Door)

    assert @custom.enc.instance_of?(Fire) 
    assert @custom.room_inv.instance_of?(Inventory)

    expected = {:feet=>nil, :head=>"helmet", :mood=>"hope", :torso=>nil, :trinket=>nil, :weapon=>nil}
    assert_equal expected, @custom.room_inv.equipment
    assert @custom.room_inv.equipment.instance_of?(Hash)

    assert @custom.room_inv.loot.instance_of?(Array)
    expected = ["penny", "lint"]
    assert_equal expected, @custom.room_inv.loot

    assert_equal "This is a test room.", @custom.room_desc
  end

  def test_equal
    refute_equal @default, @custom

    another_default = Room.new
    assert_equal another_default, @default
  end





  def test_default_to_h
    results = {:description=>"",
      :doors=>{},
      :encounter=>{:params=>{:blocking=>false}, :type=>"NoEnc"},
      :inventory=>
       {:equipment=>
         {:feet=>nil,
          :head=>nil,
          :mood=>nil,
          :torso=>nil,
          :trinket=>nil,
          :weapon=>nil},
        :loot=>[]}}
    assert_equal results, @default.to_h 
  end

  def test_custom_to_h
    results = {:description=>"This is a test room.",
      :doors=>
       {:N=>
         {:description=>"You move to the next room.",
          :destination=>{:back=>"H", :x=>2, :y=>3}}},
      :encounter=>{:params=>{:blocking=>true}, :type=>"Fire"},
      :inventory=>
       {:equipment=>
         {:feet=>nil,
          :head=>"helmet",
          :mood=>"hope",
          :torso=>nil,
          :trinket=>nil,
          :weapon=>nil},
        :loot=>["penny", "lint"]}}
    assert_equal results, @custom.to_h 
  end

end