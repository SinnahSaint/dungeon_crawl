require 'yaml'
require "FileUtils"

require_relative 'monkey_patch_hash.rb'
require_relative 'utility.rb'
require_relative 'interface/main_menu.rb'
require_relative 'interface/game_null.rb'
require_relative 'interface/game_loader.rb'
require_relative 'interface/game.rb'

require_relative 'interface/game/avatar.rb'
require_relative 'interface/game/door.rb'
require_relative 'interface/game/inventory.rb'
require_relative 'interface/game/location.rb'
require_relative 'interface/game/map.rb'
require_relative 'interface/game/room.rb'

Dir["./interface/game/encounters/*.rb"].each do |file_name|
  require file_name
end

class UserInterface
  attr_accessor :game

  def initialize(input: $stdin, output: $stdout)
    @input = input
    @output = output
    @game_loader = GameLoader.new(ui: self)
    @game = GameNull.new(ui: self)
  end

  def prompt
    if @game.is_a? Game
      output @game.prompt
    else
      output Utility.text_block("menu_prompt")
    end
  end

  def run
    catch(:exit_app_loop) do
      prompt
      run_loop
    end
  end

  def run_loop
    loop do
      handle_command(user_input)
      prompt
    end
  end
    
  def user_input
    @input.gets.chomp.downcase
  end
  
  def output(message)
    @output.puts message
  end
  
  def missing_command
    if @game.is_a? Game
      "Type in what you want to do. Try ? if you're stuck."
    else
      "I don't understand. Try ? if you're stuck."
    end
  end

  def help
    if @game.is_a? Game
      output Utility.text_block("help")
    else
      output Utility.text_block("menu_help")
    end
  end

  def boss_emergency
    if @game.is_a? Game
      now = Time.now
      save_path = @game_loader.build_save_path("boss_#{now.day}#{now.hour}")
      @game_loader.save_to_file(save_path.to_s)
    end
    output Utility.text_block("boss_emergency")
    throw(:exit_app_loop)
  end

  def quit
    if @game.is_a? Game
      output "Do you want to save first?"
       if user_input == "yes"
        output "Please type a save name for your file."
        @game_loader.save_to_file(build_save_path(user_input))
        output "Game saved."
       end
        @game = GameNull.new(ui: self)
        ""
    
    else
      output "Are you sure you want to exit?"
      throw(:exit_app_loop) if user_input == "yes"
    end
  end

  def start_a_game
    if @game.is_a? Game
      "You can't start a game from inside a game."
    else
      @game_loader.new_game
    end
  end

  def load_a_game(save_name)
    if @game.is_a? Game
      output "You can't start a game from inside a game."
    else
      @game_loader.load_saved_game(save_name)
    end
  end

  def save_the_game
    unless @game.is_a? Game
      output "There is no current game to save."
      return
    end

    output "Please choose a file name."
    save_name = user_input
    if @game_loader.saves_avail.include? save_name
      output "That name is taken already."
      save_the_game
    else
      @game_loader.save_to_file(build_save_path(save_name))
      @game = Game_null(self)
      output "Game saved."
    end
  end

  def files_avail
   output "Please choose from one of the available file names:"
   output Utility.english_list(@game_loader.saves_available)
  end

  def handle_command(cmdstr)
  
    first, second, third, fourth = cmdstr.split(" ")  

    replacements = {
      'north' => 'N',
      'east' => 'E',
      'south' => 'S',
      'west' => 'W',
      'up' => 'U',
      'down' => 'D',
      'i' => 'inventory',
      'inv' => 'inventory',
      '?' => 'help',
      'exit'=> 'quit',
    }
    
    first = replacements[first] || first
    
    output case first
            when "new"
              start_a_game
            when "save"
              save_the_game
            when "load"
              @game_loader.load_saved_game(second)
            when "quit"
              quit
            when "!"
              boss_emergency 
            when "help"
              help
            when nil
              missing_command
            when "debug"
              @game.debug
            when "debuggame"
              PP.pp(@game.debug_game, "")
            when "teleport"
              @game.teleport(Location.new(y: second.to_i, x: third.to_i, back: fourth))
            when "N","E","S","W","U","D"
              @game.attempt_to_walk(first)
            when "hint"
              @game.hint
            when "inventory"
              @game.check_avatar_inventory
            when "look"
              @game.check_room_inventory
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
end
