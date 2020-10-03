require 'test/unit'
require 'stringio'
require_relative '../app/user_interface.rb'

class UserInterfaceTest < Test::Unit::TestCase
  
  def setup
    @output = StringIO.new
    @input = StringIO.new
    @ui = UserInterface.new(input: @input, output: @output)
    @app = App.new(ui: @ui)
    def @app.run_loop ; end
  end
  
  def target_change_test
    @ui.run # game stars as nil in UI
    assert_match " - -   MAIN MENU   - - ", @output.string
    refute_match "What's next? >", @output.string
    
    @ui.game = Game.new(input: @input, output: @output) # sets game in UI
    @ui.run
    assert_match "What's next? >", @output.string
  end
  
  # def test_handle_command_no_game
 #    mappings = {
 #      "" => :missing_command,
 #      "?" => :help,
 #      "help" => :help,
 #      "quit" => :quit,
 #      "exit" => :quit,
 #    }
 #
 #    def @user_interface.call_counts
 #      @call_counts ||= Hash.new { 0 }
 #    end
 #
 #    mappings.values.each do |sym|
 #      @user_interface.define_singleton_method(sym) do |*args|
 #        call_counts[sym] += 1
 #      end
 #    end
 #
 #    mappings.each do |command, method|
 #      before = @user_interface.call_counts[method]
 #      @user_interface.handle_command(command)
 #      after = @user_interface.call_counts[method]
 #      assert_equal before + 1, after
 #    end
 #  end
 #
 #  def test_handle_command_no_game
 #    @game = Game.new(ui: @ui)
 #
 #    mappings = {
 #      "" => :missing_command,
 #      "debug" => :debug,
 #      "debuggame" => :debug_game,
 #      "teleport" => :teleport,
 #      "north" => :attempt_to_walk,
 #      "n" => :attempt_to_walk,
 #      "east" => :attempt_to_walk,
 #      "e" => :attempt_to_walk,
 #      "south" => :attempt_to_walk,
 #      "s" => :attempt_to_walk,
 #      "west" => :attempt_to_walk,
 #      "w" => :attempt_to_walk,
 #      "?" => :help,
 #      "help" => :help,
 #      "hint" => :hint,
 #      "i" => :check_inventory,
 #      "inv" => :check_inventory,
 #      "inventory" => :check_inventory,
 #      "quit" => :quit,
 #      "exit" => :quit,
 #      "take" => :move_item,
 #      "drop" => :move_item,
 #    }
 #
 #    def @user_interface.call_counts
 #      @call_counts ||= Hash.new { 0 }
 #    end
 #
 #    mappings.values.each do |sym|
 #      @user_interface.define_singleton_method(sym) do |*args|
 #        call_counts[sym] += 1
 #      end
 #    end
 #
 #    mappings.each do |command, method|
 #      before = @user_interface.call_counts[method]
 #      @user_interface.handle_command(command)
 #      after = @user_interface.call_counts[method]
 #      assert_equal before + 1, after
 #    end
 #  end



end
