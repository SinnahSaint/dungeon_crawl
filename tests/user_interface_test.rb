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
  
  


end
