require 'test/unit'

require './interface/game/location.rb'

class LocationTest < Test::Unit::TestCase

  def setup
    @location = Location.new(x: 3, y: 4, back: "south")
  end

  def test_initialize
    assert_equal 3, @location.x
    assert_equal 4, @location.y
    assert_equal "S", @location.back
  end

  def test_equal
    first = Location.new(x: 3, y: 4, back: "S") # Should be same
    second = Location.new(x: 3, y: 4, back: "N") # Diff back but should ==
    third = Location.new(x: 2, y: 4, back: "S") # Diff x
    fourth = Location.new(x: 3, y: 3, back: "S") # Diff y

    assert @location == first
    assert @location == second
    assert @location != third
    assert @location != fourth
  end

  def test_to_h
    results = {back: "S", x: 3, y: 4}
    assert_equal results, @location.to_h 
  end

end