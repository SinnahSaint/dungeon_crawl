require 'test/unit'
require 'stringio'
require './interface.rb'

class InterfaceTest < Test::Unit::TestCase

  def setup
    @output = StringIO.new
    @input = StringIO.new
    @ui = UserInterface.new(input: @input, output: @output)
  end

  def test_init
    assert @ui.instance_of?(UserInterface)
    assert @ui.game.instance_of?(GameNull)
    assert @ui.game_loader.instance_of?(GameLoader)
  end

  def test_handle_command
    ## This only handles ui specific commands.
    ## Talk to Meg re: @game and @game_loader directed calls
    mappings = {
      "" => :missing_command,
      "new" => :start_a_game,
      "save" => :save_the_game,
      "quit" => :quit,
      'exit' => :quit,
      "!" => :boss_emergency,
      "help" => :help,
      '?' => :help,
      }
      
      def @ui.call_counts
        @call_counts ||= Hash.new { 0 }
      end
      mappings.values.each do |sym| 
        @ui.define_singleton_method(sym) do |*args|
          call_counts[sym] += 1               
        end                                   
      end
      
      mappings.each do |command, method|
        before = @ui.call_counts[method]
        @ui.handle_command(command)
        after = @ui.call_counts[method]
        assert_equal before + 1, after 
      end
  end


end