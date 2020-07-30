require 'test/unit'
require_relative '../utility.rb'

class EnglishListTest < Test::Unit::TestCase
  
  def test_english_list_of_none
    array = %w[]
    assert_equal Utility.english_list(array), ""
  end

  def test_english_list_of_one
    array = %w[one]
    assert_equal Utility.english_list(array), "one" 
  end

  def test_english_list_of_two
    array = %w[one two]    
    assert_equal Utility.english_list(array), "one and two"     
  end
  
  def test_english_list_of_three
    array = %w[one two three]  
    assert_equal Utility.english_list(array), "one, two, and three"      
  end
  
  def test_english_list_of_nine
    array = %w[one two three four five six seven eight nine]  
    assert_equal Utility.english_list(array),  "one, two, three, four, five, six, seven, eight, and nine"    
  end
  
  def test_english_list_of_numbers
    array = [1, 2, 3, 4]
    assert_equal Utility.english_list(array), "1, 2, 3, and 4"
  end

end


class EncounterStub
  attr_accessor :state, :blocking
  def initialize
    @blocking = false
    @state =  "There's a huge pile of rocks. It kind of reminds you of the Alpine Mountains."  
  end
end

class RoomLikeStub
  attr_accessor :lay, :enc, :inventory, :description
  def initialize
    @lay = %w[east south west]
    @enc = EncounterStub.new        
    @inventory = %w[gemstone stone]
    @description = "A dusty room full of rubble. "
  end
end
  
class AvatarStub
  attr_accessor :inventory, :back, :location
  def initialize
    @inventory = %w[lint penny]
    @back = "south"
    @location = [2, 2]
  end
end


class DebugTest < Test::Unit::TestCase

  def setup
    @current_room = RoomLikeStub.new
    @avatar = AvatarStub.new
  end

  def test_debug
    assert_equal Utility.debug(@current_room, @avatar),<<~HERE
    #{"- " * 20}
    #{"- " * 20}
    room description: A dusty room full of rubble. 
    room inventory: gemstone, stone
    room layout: east, south, west
    room enc: EncounterStub
    enc blocking: false
    enc state: There's a huge pile of rocks. It kind of reminds you of the Alpine Mountains.
    #{"- " * 20}
    avatar inventory: lint, penny
    back direction: south
    avatar location: 2, 2
    #{"- " * 20}
    #{"- " * 20}
    HERE
  end

  def teardown
  end


end