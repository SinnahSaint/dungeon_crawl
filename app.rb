require_relative 'app/game.rb'
require_relative "app/utility.rb"


class App
  
  def initialize(input: $stdin, output: $stdout)
    @input = input
    @output = output
    
    @output.puts Utility.text_block("menu")
    menu_loop
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
  
  def random_map
    @maps_avail = []
    
    Dir["./maps/*.yaml"].each do |map_name|
      @maps_avail << map_name.to_s
    end
    
    @maps_avail.sample
  end

  def new_game
    @game = Game.new(map_file: random_map).run
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

