require 'test/unit'
require 'ostruct'
require 'stringio'
require_relative '../app.rb'
require_relative '../app/player.rb'
require_relative '../app/room.rb'
require_relative '../app/utility.rb'
require_relative '../app/location.rb'
require_relative '../encounters/no_enc.rb'
require_relative '../encounters/fire.rb'
require_relative '../encounters/ice.rb'

class AppTest < Test::Unit::TestCase

  DEFAULT_START_LOCATION = { y: 0, x: 1, back: "south" }

  def setup
    @avatar = Player.new(self)
    start = DEFAULT_START_LOCATION
    test_map = {
      level: [
         [
           Room.new(layout: :e, description: "A literally boring nothing room. "
                    ), 
           Room.new(layout: :esw, 
                    encounter: Fire.new, 
                    inventory: ["knife"], 
                    description: "A kitchen with a nice table. ",
                    ), 
           Room.new(layout: :w, 
                    encounter: Ice.new, 
                    description: "This room is really cold for no good reason. ",
                    ),
         ],
      ],
      win: Location.new(x: 1, y: 1),
      start: [Location.new(x: start[:x], y: start[:y]), start[:back]], 
    }
    
    @output = StringIO.new
    @input = StringIO.new
    @game = App.new(avatar: @avatar, map: test_map, output: @output, input: @input)
  end
  
  # def test_default_init
  #   game = App.new
  #   save_state = game.save_state
  #
  #   assert_equal %w(lint penny hope), save_state[:avatar][:inventory]
  #   assert_equal [2,1], save_state[:avatar][:location]
  #
  #   assert_equal "A kitchen with a nice table. ",
  #     save_state[:current_map][:level][0][0][:description]
  #
  #   expected = {
  #     avatar: {
  #       back: "south",
  #       inventory: ["lint", "penny", "hope"],
  #       location: [2, 1]
  #     },
  #     current_map: {
  #       level: [
  #         [ { description: "A kitchen with a nice table. ",
  #             enc: { blocking: true,
  #                    class: "Fire",
  #                    inventory: []
  #                  },
  #             inventory: ["knife"],
  #             lay: ["east", "south"]
  #           },
  #           { description: "This room looks like you walked into a bandit's home office. ",
  #             enc: { blocking: true,
  #                    class: "Killer",
  #                    dead: false,
  #                    friend: false,
  #                    inventory: []
  #             },
  #             inventory: [],
  #             lay: ["east", "south", "west"]
  #           },
  #           { description: "A dusty room full of rubble. ",
  #             enc: { blocking: false,
  #                    class: "Avalanche",
  #                    inventory: []
  #                  },
  #             inventory: ["gemstone"],
  #             lay: ["west"]
  #           }
  #         ],
  #         [ { description: "A literally boring nothing room. ",
  #             enc: { blocking: false,
  #                    class: "NoEnc",
  #                    inventory: []
  #                  },
  #             inventory: [],
  #             lay: ["north", "south"]
  #           },
  #           { description: "A lovely room filled with gold. ",
  #             enc: { blocking: false,
  #                    class: "NoEnc",
  #                    inventory: []
  #                  },
  #             inventory: ["gold"],
  #             lay: ["north"]
  #           },
  #           { description: "A mostly empty room with straw on the floor. ",
  #             enc: { blocking: false,
  #                    class: "Cow",
  #                    has_milk: true,
  #                    inventory: [],
  #                    milked: false
  #                  },
  #             inventory: [],
  #             lay: ["south"]
  #           }
  #         ],
  #         [
  #           { description: "A throne room, with no one on the throne. ",
  #             enc: { blocking: false,
  #                    class: "Jester",
  #                    inventory: [],
  #                    joke: false
  #                  },
  #             inventory: [],
  #             lay: ["north", "east"]
  #           },
  #           { description: "A literally boring nothing room. ",
  #             enc: { blocking: false,
  #                    class: "NoEnc",
  #                    inventory: []
  #                  },
  #             inventory: [],
  #             lay: ["east", "south", "west"]
  #           },
  #           { description: "This room is really cold for no good reason. ",
  #             enc: { blocking: false,
  #                    class: "Ice",
  #                    inventory: []
  #                  },
  #             inventory: [],
  #             lay: ["north", "west"]
  #           }
  #         ]
  #       ],
  #       start: [2, 1, "south"],
  #       win: [3, 1]
  #     }
  #   }
  #   assert_equal expected, save_state
  #
  # end
  
  def test_display
    @game.display("test display msg")
    assert_match "test display msg", @output.string
  end
  
  def test_run_loop
    begin
      @input.string = "\nexit\n"  # exit exits!
      @game.run
    rescue SystemExit
      # stop exit exiting
    end
    # assert we got "What's next?" twice
    assert_equal(3, @output.string.split("What's next?").size)
  end
  
  def test_text_block
    File.open("./text_blocks/test.txt",'w') do |file|
        file.write "This is a test file.\n"
        file.write "Nothing to see here."
    end
        
    assert_equal " "*27 + "This is a test file." + " "*27 + "\n" +
                 " "*27 + "Nothing to see here." + " "*27, 
                 @game.text_block("test")
      
    File.delete("./text_blocks/test.txt")    
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
      @game.attempt_to_walk("south")
      assert_equal Location.new(x: 1, y: 1), @avatar.location
    rescue SystemExit
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
      @game.attempt_to_walk("south")
      assert_equal Location.new(x: 1, y: 1), @avatar.location
    rescue SystemExit
    end
  end
  
  def test_move_avatar
    assert_equal DEFAULT_START_LOCATION, @avatar.location.to_h.merge({back: @avatar.back})
    
    new_location = Location.new(x: 2, y: 1)
    @game.move_avatar(new_location, "back")
    assert_equal new_location, @avatar.location
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
