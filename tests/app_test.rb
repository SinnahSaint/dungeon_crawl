require 'test/unit'
require 'ostruct'
require 'stringio'
require_relative '../app.rb'
require_relative '../player.rb'
require_relative '../room.rb'
require_relative '../template.rb'
require_relative '../utility.rb'
require_relative '../encounters/no_enc.rb'
require_relative '../encounters/fire.rb'
require_relative '../encounters/ice.rb'

class AppTest < Test::Unit::TestCase


  
  def test_run_loop 
  end
  
  def test_text_block
  end
  def test_check_inventory
    assert_equal "Your inventory includes: \n * lint\n * penny\n * hope ", 
      @game.check_inventory
    @avatar.remove_item("lint")
    @avatar.remove_item("penny")
    assert_equal "Your inventory includes: \n * hope ", @game.check_inventory
    @avatar.remove_item("hope")
    assert_equal "You're not carrying anything.", @game.check_inventory
   end

  def test_move_item
  end
  def test_walk
  # how to I test for the outgoing? this is just a switch sending to other methods
  # assert @game.walk("garbage") 
  # it sends the error message to display, but the test says it evaluates to nil? 
  
  # Don't test "walk" it is essentially an implementation "detail"
  # Tested in "test_attempt_to_walk"
  end
  
  def test_move_avatar
    assert_equal @map_start, [@avatar.location, @avatar.back].flatten
    @game.move_avatar(1, 2, "back")
    assert_equal [1, 2], @avatar.location
    assert_equal "back", @avatar.back
    
    # expect(@avatar.back).to equal("back")  # RSpec
  end
  
  def test_game_over  
    assert_raise(SystemExit) do
      @game.game_over("game's done")
    end
    # expected = "game's done" actual = @output.string
    assert_match "game's done", @output.string
  end

  # def teardown
  # end
end