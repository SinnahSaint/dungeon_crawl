require_relative 'app/game.rb'
require_relative "app/utility.rb"


class App
  
  def initialize(input: $stdin, output: $stdout)
    @input = input
    @output = output
    
    @output.puts Utility.text_block("menu")
    menu_loop
    # Game.new.run
  end
  
  def prompt
    @output.puts "\nWould you like to start a NEW game? LOAD a save? or QUIT?"
  end

  def menu_loop
    Utility.text_block("menu")
    
    catch (:exit_app_loop) do
      prompt
      loop do
        command = @input.gets.chomp.downcase
        handle_command(command)
      end
    end
    
  end
  
  def handle_command(cmdstr)
   first, second = cmdstr.split(" ")  
    
    case first
      when "new" then new_game
      when "load" then load_game(file: second)
      when "quit" then quit
      else prompt
    end
  end

  def load_game(input: $stdin, output: $stdout, file: nil)
    # gonna need to move save file sorting from game into app
  end

  def new_game
    @game = Game.new.run
    #Game.new(map_file: './maps/in_and_out.yaml').run
    prompt
  end
  
  def quit
    @output.puts "Are you sure you want to quit?"
    validation = @input.gets.chomp.downcase
    if validation == "yes"
      @output.puts Utility.text_block("goodbye")
      throw :exit_app_loop 
    else
      return prompt
    end
  end
  
end







App.new

