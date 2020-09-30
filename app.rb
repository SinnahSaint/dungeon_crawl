require_relative 'app/game.rb'
require_relative "app/utility.rb"


class App
  attr_accessor :input, :output
  
  def initialize(input: $stdin, output: $stdout)
    @input = input
    @output = output
  end
  
  def prompt
    @output.puts Utility.text_block("menu_prompt")
  end
  
  def user_input
    user_input = @input.gets.chomp.downcase
    if user_input == "!"
      @output.puts Utility.text_block("boss_emergency")
      throw(:exit_app_loop)
    end
    user_input
  end

  def run
    @output.puts Utility.text_block("menu")
    
    catch(:exit_app_loop) do
      prompt
      run_app_loop
    end
  end
  
  def run_app_loop
    loop do
      command = user_input
      handle_command(command)
      prompt
    end
  end
  
  def handle_command(cmdstr)
    unless cmdstr == ""
      cmdary = cmdstr.split(" ")
      first = cmdary.first
      index = cmdary.index(first)
      cmdary.delete_at(index)
      second = cmdary.join 
    end
    case first
      when "new"  then new_game
      when "load" then load_save(file: second)
      when "quit" then quit
      when "!"    then boss_emergency # this shouldn't happen as it's caught in user_input right now
      else 
        confused
    end
  end
  
  def confused
    @output.puts "I don't understand."
  end
  
  def yaml_save_files
    Dir["./saves/*.yaml"]
  end
  
  def saves_available
    @saves_avail = []
    yaml_save_files.each do |save_name|
      @saves_avail << File.basename(save_name, ".yaml")
    end
    @saves_avail
  end

  def load_save(file: nil)
    if saves_available.include?(file)
      @game = Game.new(input: @input, 
                       output: @output,
                       )
      @game.load_game(file)
      @game.run
    else
      puts "Invalid save name '#{file}'. Nothing happens.","Please choose among the available save files:\n#{Utility.english_list(saves_available)}" 
    end
  end
  
  def random_map
    @maps_avail = []
    
    Dir["./maps/*.yaml"].each do |map_name|
      @maps_avail << map_name.to_s
    end
    
    @maps_avail.sample
  end

  def new_game
    @game = Game.new(input: @input, 
                     output: @output, 
                     map_file: random_map,
                     ).run
  end
  
  def quit
    @output.puts "Are you sure you want to quit?"
    validation = user_input
    if validation == "yes"
      @output.puts Utility.text_block("goodbye")
      throw :exit_app_loop 
    else
      return
    end
  end
  
end

