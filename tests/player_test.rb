require 'test/unit'
require 'ostruct'
require_relative '../app/player.rb'

class PlayerTest < Test::Unit::TestCase
  def setup
    @game = OpenStruct.new
    def @game.game_over(msg)
       msg + ", so sad."
    end
    @guy = Player.new(@game)
  end

  def test_init
    @guy.inventory == %w[lint penny hope]
    @guy.back == ""
    @guy.location == []   
  end
  
  def test_change_back
    assert_kind_of String, @guy.back
    assert @guy.back.empty?
    @guy.move(Location.new(x: 0, y: 0), "south")
    assert @guy.back == "south"
  end
  
  def test_change_location
    assert_nil @guy.location
    new_location = Location.new(x: 1, y: 2)
    @guy.move(new_location, "south")
    assert @guy.location == new_location
  end
  
  def test_add_item
    @guy.inventory<<"thing"
    assert @guy.inventory.include?("thing")
  end
  
  def test_has_item
    assert_equal @guy.has_item?("item"), false
    assert_equal @guy.has_item?("hope"), true    
  end
  
  def test_remove_item
    @guy.remove_item("hope")
    assert @guy.inventory.none?("hope")
    assert @guy.inventory.include?("lint")
    assert @guy.inventory.include?("penny")
  end
  
  def test_leave
    assert_equal @guy.leave("too bad"), "too bad, so sad."
  end
end
