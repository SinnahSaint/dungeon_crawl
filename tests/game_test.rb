require 'test/unit'
require 'ostruct'
require 'stringio'
require_relative '../app/game.rb'
require_relative '../app/user_interface.rb'
require_relative '../app/player.rb'
require_relative '../app/room.rb'
require_relative '../app/utility.rb'
require_relative '../app/location.rb'
require_relative '../encounters/no_enc.rb'
require_relative '../encounters/fire.rb'
require_relative '../encounters/ice.rb'

class GameTest < Test::Unit::TestCase

  DEFAULT_START_LOCATION = Location.new(y: 0, x: 1)
  DEFAULT_START_BACK     = "south"

  def setup
    @test_map = {
      "map" => {
        "level" =>[
         [
           {"layout" => "E", 
            "description" => "A literally boring nothing room. "
           }, 
           {"layout" => "ESW", 
            "encounter" => "Fire", 
            "inventory" => ["knife"], 
            "description" => "A kitchen with a nice table. ",
           }, 
           {"layout" => "W", 
            "encounter" => "Ice", 
            "description" => "This room is really cold for no good reason. ",
           },
          ]
        ],
        "win" => {"x" => 1, "y" => 1},
        "start" => {"y" => 0, "x" => 1, "back" => "south"},
      }
    }
    
    @output = StringIO.new
    @input = StringIO.new
    @ui = UserInterface.new(input: @input, output: @output)
    @game = Game.new(ui: @ui, map: MapLoader.new(@test_map).generate)
    @avatar = @game.avatar
  end
  
  def test_default_init
    save_state = @game.save_state
    
    assert_equal %w(lint penny hope), save_state[:avatar][:inventory]
    assert_equal @test_map["map"]["start"]["x"], save_state[:avatar][:location][:x]
    assert_equal @test_map["map"]["start"]["y"], save_state[:avatar][:location][:y]
    assert_equal @test_map["map"]["start"]["back"], save_state[:avatar][:back]
                  
    expected = {
      :avatar=>{
        :back=>"south",
        :inventory=>["lint", "penny", "hope"],
        :location=>{:x=>1, :y=>0}
        },
      :level=>[
        [{:enc=>{:blocking=>false}, :inventory=>[]},
        {:enc=>{:blocking=>true}, :inventory=>["knife"]},
        {:enc=>{:blocking=>false}, :inventory=>[]}]
        ],
      :map_file=>"./maps/spiral.yaml"
      }
    assert_equal expected, save_state
  end

  def test_handle_command
    mappings = {
      "" => :missing_command,
      "debug" => :debug,
      "debuggame" => :debug_game,
      "teleport" => :teleport,
      "north" => :attempt_to_walk,
      "n" => :attempt_to_walk,
      "east" => :attempt_to_walk,
      "e" => :attempt_to_walk,
      "south" => :attempt_to_walk,
      "s" => :attempt_to_walk,
      "west" => :attempt_to_walk,
      "w" => :attempt_to_walk,
      "?" => :help,
      "help" => :help,
      "hint" => :hint,
      "i" => :check_inventory,
      "inv" => :check_inventory,
      "inventory" => :check_inventory,
      "quit" => :quit,
      "exit" => :quit,
      "take" => :move_item,
      "drop" => :move_item,
    }

    def @game.call_counts
      @call_counts ||= Hash.new { 0 }
    end

    mappings.values.each do |sym|
      # def @game.teleport(*args)
      #  call_counts[:teleport] += 1
      # end
      @game.define_singleton_method(sym) do |*args|
        call_counts[sym] += 1
      end
    end

    mappings.each do |command, method|
      before = @game.call_counts[method]
      @game.handle_command(command)
      after = @game.call_counts[method]
      assert_equal before + 1, after
    end
  end
  # def test_run_loop
  #   @input.string = "\nexit\nno\n"
  #   @game.run
  #   # assert we got "What's next?" twice
  #   assert_equal(3, @output.string.split("What's next?").size)
  # end

  def test_check_with_encounter
    enc = @game.current_room.enc
    def enc.called?
      @called
    end
    def enc.handle_command(*_args)
      @called = true
    end

    @game.check_with_encounter("")

    assert enc.called?
  end

  def test_current_room
    @avatar.move(Location.new(x: 0, y: 0), "south")
    zero = @game.current_room
    @avatar.move(Location.new(x: 1, y: 0), "south")
    one = @game.current_room
    @avatar.move(Location.new(x: 2, y: 0), "south")
    two = @game.current_room

    assert_not_equal zero, one
    assert_not_equal zero, two
    assert_not_equal one, two
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
    @avatar.move(Location.new(x: 1, y: 0), "south")

    @game.move_item("knife", @game.current_room, @avatar)
    assert_equal %w[lint penny hope knife], @avatar.inventory
    assert_equal %w[], @game.current_room.inventory

    @game.move_item("penny", @avatar, @game.current_room)
    assert_equal %w[lint hope knife], @avatar.inventory
    assert_equal %w[penny], @game.current_room.inventory
  end

  def test_attempt_to_walk
    reset_location = ->{ @avatar.move(Location.new(x: 1, y: 0), "south") }
    
    blocked_message = "You'll have to deal with this or go back."
    
    # Room blocked (see setup) - can only go back
        
    reset_location.call
    assert_equal "That's a wall dummy.", @game.attempt_to_walk("north")
    
    reset_location.call
    assert_equal blocked_message, @game.attempt_to_walk("west")
    
    reset_location.call
    assert_equal blocked_message, @game.attempt_to_walk("east")
    
    begin
      reset_location.call
      catch(:exit_game_loop) do
        @game.attempt_to_walk("south")
        assert_equal Location.new(x: 1, y: 1), @avatar.location
      end
    end
    
    # Unblock the room (using milk, see setup) - can go ESW
    
    reset_location.call
    @avatar.inventory << "milk"
    @game.current_room.enc.handle_command("use milk", @avatar)
    
    assert_equal "That's a wall dummy.", @game.attempt_to_walk("north")
    
    reset_location.call
    @game.attempt_to_walk("west")
    assert_equal Location.new(x: 0, y: 0), @avatar.location

    reset_location.call
    @game.attempt_to_walk("east")
    assert_equal Location.new(x: 2, y: 0), @avatar.location
    
    begin
      reset_location.call
      catch(:exit_game_loop) do
        @game.attempt_to_walk("south")
        assert_equal Location.new(x: 1, y: 1), @avatar.location
      end
    end
  end

  def test_move_avatar
    assert_equal DEFAULT_START_LOCATION, @avatar.location

    new_location = Location.new(x: 2, y: 1)
    @game.move_avatar(new_location, "back")
    assert_equal new_location, @avatar.location
    assert_equal "back", @avatar.back

    # expect(@avatar.back).to equal("back")  # RSpec
  end

  def test_game_over
    catch :exit_game_loop do
      @game.game_over("game's done")
    end
    # expected = "game's done" actual = @output.string
    assert_match "game's done", @output.string
  end

end
