require 'test/unit'
require_relative '../app/map.rb'

class MapTest < Test::Unit::TestCase
  
  # def test_empty_init
  #   test_map = Map.new
  #   expected = [
  #     [Room.new(Map::LAY[:es], Map::TEMP[:f]), Room.new(Map::LAY[:esw], Map::TEMP[:k]), Room.new(Map::LAY[:w], Map::TEMP[:a])],
  #     [Room.new(Map::LAY[:ns], Map::TEMP[:n]), Room.new(Map::LAY[:n], Map::TEMP[:g]),   Room.new(Map::LAY[:s], Map::TEMP[:c])],
  #     [Room.new(Map::LAY[:ne], Map::TEMP[:j]), Room.new(Map::LAY[:esw], Map::TEMP[:n]), Room.new(Map::LAY[:nw], Map::TEMP[:i])],
  #     ]
  #   assert_equal expected, test_map.level
  #   assert [2, 1, "south"] == test_map.start
  #   assert [3, 1] == test_map.win
  # end

  # def test_full_init
  #   test_map = Map.new({
  #     level:[
  #       [
  #       Room.new(Map::LAY[:ne], Map::TEMP[:j]),
  #       Room.new(Map::LAY[:esw], Map::TEMP[:n]),
  #       Room.new(Map::LAY[:nw], Map::TEMP[:i]),
  #       ]
  #     ],
  #     start: [0, 2, "north"],
  #     win: [1, 3],
  #     })
  #
  #     expected = [
  #       [
  #       Room.new(Map::LAY[:ne], Map::TEMP[:j]),
  #       Room.new(Map::LAY[:esw], Map::TEMP[:n]),
  #       Room.new(Map::LAY[:nw], Map::TEMP[:i]),
  #       ]
  #     ]
  #     assert_equal expected, test_map.level
  #     assert_equal [0, 2, "north"], test_map.start
  #     assert_equal [1, 3], test_map.win
  # end

end
