require_relative 'game.rb'

class CommandHandler  
  def initialize(input: $stdin, output: $stdout)
    @input = input
    @output = output
  end
  
  # for now, until game knows about CommmandHandler
  def private_output
    @output
  end
  
  def private_input
    @input
  end
  
  def app=(value)
    @app = value
  end
  
  def output(message)
    @output.puts message
  end
  
  def target
    @game || @app
  end
  
  def run
    target.prompt
    catch(:exit_app_loop) do
      run_loop
    end
  end
  
  def run_loop
    loop do
      handle_command(user_input)
      target.prompt
    end
  end
  
  def user_input
    @input.gets.chomp.downcase
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
      when "new"  then @app.new_game
      when "load" then @app.load_save(file: second)
      when "quit" then target.quit
      when "!"    then target.boss_emergency 
      else 
        confused
    end
  end
  
  def confused
    @output.puts "I don't understand."
  end
  
end
