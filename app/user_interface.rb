require_relative 'game.rb'
require_relative 'game_null.rb'

class UserInterface
  attr_reader :app

  def initialize(input: $stdin, output: $stdout)
    @input = input
    @output = output
  end

  def run
    catch(:exit_app_loop) do
      target.prompt
      run_loop
    end
  end
  
  def app=(value)
    @app = value
    @game = GameNull.new(self)
  end
  
  def game=(value)
    @game = value
  end
  
  def user_input
    @input.gets.chomp.downcase
  end
  
  def output(message)
    @output.puts message
  end
  
  def handle_command(cmdstr)
  
    first, second, third, fourth = cmdstr.split(" ")  

    replacements = {
      'n' => 'north',
      'e' => 'east',
      's' => 'south',
      'w' => 'west',
      'i' => 'inventory',
      'inv' => 'inventory',
      '?' => 'help',
      'exit'=> 'quit'
    }
    
    first = replacements[first] || first
    
    output case first
            when "new"
              target.new_game
            when "load"
              target.load_save(file: second)
            when "quit"
              target.quit
            when "!"
              target.boss_emergency 
            when "help"
              target.help
            when nil
              missing_command
            when "debug"
              @game.debug
            when "debuggame"
              PP.pp(@game.debug_game, "")
            when "teleport"
              @game.teleport(Location.new(y: second.to_i, x: third.to_i), fourth)
            when "north", "east", "south", "west"
              @game.attempt_to_walk(first)
            when "hint"
              @game.hint
            when "inventory"
              @game.check_inventory
            when "take"
              @game.move_item(second, @game.current_room, @game.avatar, 
                        on_success: "You #{first} the #{second}.",
                        on_fail: "Whoops! There's no #{second} you can take with you here.")
            when "drop"
              @game.move_item(second, @game.avatar, @game.current_room,
                        on_success: "You #{first} the #{second}.",
                        on_fail: "Whoops! No #{second} in inventory.")
            else
              @game.check_with_encounter(cmdstr)
            end
  end

  def target
    return @game if @game.is_a? Game

    @app
  end

  def run_loop
    loop do
      handle_command(user_input)
      target.prompt
    end
  end

  def missing_command
    if @game.is_a? Game
      "Type in what you want to do. Try ? if you're stuck."
    else
      "I don't understand. Try ? if you're stuck."
    end
  end

end
