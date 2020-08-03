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

  def setup
    @avatar = Player.new(self)
    lay = {
      e: %w[east],
      w: %w[west],
      esw: %w[east south west],
    }
    temp = {
      f: Template.new(encounter: ->{Fire.new}, 
                      inventory: ["knife"], 
                      description: "A kitchen with a nice table. ",
                      ),
      i: Template.new(encounter: ->{Ice.new}, 
                      description: "This room is really cold for no good reason. ",
                      ),
      n: Template.new(description: "A literally boring nothing room. "
                      ),
    }
    map = [
      [Room.new(lay[:ne], temp[:n]), 
       Room.new(lay[:esw], temp[:f]), 
       Room.new(lay[:nw], temp[:i]),
       ]
     ]
    
    @map_start = [0, 1, "south"]
    
    @output = StringIO.new
    
    @game = App.new(avatar: @avatar, map: map, map_start: @map_start, output: @output)
  end
  
  def test_display
   @game.display("test display msg")
   assert_match "test display msg", @output.string
  end
  
  def test_run_loop 
    
  end
  
  def test_text_block
    File.open("./text_blocks/test.txt",'w') do |file|
        file.write "This is a test file.\n"
        file.write "Nothing to see here."
    end
    # File.close("./text_blocks/test.txt") # needed? or does do-block close?
        
    assert_equal " "*28 + "This is a test file." + " "*28 + "\n" +
                 " "*28 + "Nothing to see here." + " "*28, 
                 @game.text_block("test")
      
    File.delete("./text_blocks/test.txt")    
  end
  
  def test_handle_command
    mappings = {
      "" => :missing_command,
      "debug" => :debug,
      "teleport" => :teleport,
      "north" => :attempt_to_walk,
      "n" => :attempt_to_walk,
      "east" => :attempt_to_walk,
      "e" => :attempt_to_walk,
      "south" => :attempt_to_walk,
      "s" => :attempt_to_walk,
      "west" => :attempt_to_walk,
      "w" => :attempt_to_walk,
      "?" => :text_block,
      "help" => :text_block,
      "hint" => :hint,
      "i" => :check_inventory,
      "inv" => :check_inventory,
      "inventory" => :check_inventory,
      "quit" => :game_over,
      "exit" => :game_over,
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
    @avatar.location = [0, 0]
    zero = @game.current_room
    @avatar.location = [0, 1]
    one = @game.current_room
    @avatar.location = [0, 2]
    two = @game.current_room
    
    assert_not_equal zero, one
    assert_not_equal zero, two
    assert_not_equal one, two 
  end

  def test_look
    expected = <<~TEXT
    A kitchen with a nice table. 
    OMG the table's on fire!
    In this room you can see: knife
    There are exits to the east and west, or south, back the way you came.
    TEXT
    
    @game.look # outputs to @output via "puts"
    
    assert_equal expected, @output.string
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
    @avatar.location = [0,1]
    
    @game.move_item("knife", @game.current_room, @avatar)
    assert_equal %w[lint penny hope knife], @avatar.inventory
    assert_equal %w[], @game.current_room.inventory
    
    @game.move_item("penny", @avatar, @game.current_room)
    assert_equal %w[lint hope knife], @avatar.inventory
    assert_equal %w[penny], @game.current_room.inventory
  end
  
  def test_attempt_to_walk
    reset_location = ->{
      @avatar.back = "south"
      @avatar.location = [0, 1]
    }
    
    blocked_message = "You'll have to deal with this or go back."
    
    reset_location.call
    assert_equal "That's a wall dummy.", @game.attempt_to_walk("north")
    
    reset_location.call
    assert_equal blocked_message, @game.attempt_to_walk("west")
    
    reset_location.call
    assert_equal blocked_message, @game.attempt_to_walk("east")
    
    reset_location.call
    @game.attempt_to_walk("south")
    assert_equal [1, 1], @avatar.location
    
    reset_location.call
    @avatar.inventory << "milk"
    @game.current_room.enc.handle_command("use milk", @avatar)
    
    assert_equal "That's a wall dummy.", @game.attempt_to_walk("north")
    
    reset_location.call
    @game.attempt_to_walk("west")
    assert_equal [0, 0], @avatar.location

    reset_location.call
    @game.attempt_to_walk("east")
    assert_equal [0, 2], @avatar.location
    
    reset_location.call
    @game.attempt_to_walk("south")
    assert_equal [1, 1], @avatar.location
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

end