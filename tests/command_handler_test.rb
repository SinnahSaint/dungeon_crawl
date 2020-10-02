require 'test/unit'
require 'stringio'
require_relative '../app/command_handler.rb'

class CommandHandlerTest < Test::Unit::TestCase
  

# def test_user_input
#   @input.string = "HeLLo\n"
#   assert_equal "hello", @app.user_input
#
#   catch(:exit_app_loop) do
#     @input.string = "!\n"
#     @app.user_input
#     assert false, "Expected :exit_app_loop to throw, but it didn't"
#   end
# end

# def test_handle_command
#   mappings = {
#     "new"     => :new_game,
#     "load"    => :load_save,
#     "quit"    => :quit,
#     ""        => :confused,
#     "run"     => :confused,
#     ";kad;jn" => :confused,
#     "!"       => :boss_emergency,
#   }
#
#   def @app.call_counts
#     @call_counts ||= Hash.new { 0 }
#   end
#
#   mappings.values.each do |sym|
#     # def @game.teleport(*args)
#     #  call_counts[:teleport] += 1
#     # end
#     @app.define_singleton_method(sym) do |*args|
#       call_counts[sym] += 1
#     end
#   end
#
#   mappings.each do |command, method|
#     before = @app.call_counts[method]
#     @app.handle_command(command)
#     after = @app.call_counts[method]
#     assert_equal before + 1, after
#   end
# end


end
