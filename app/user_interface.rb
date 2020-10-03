require_relative 'game.rb'

class UserInterface
    
  def initialize(input: $stdin, output: $stdout)
    @input = input
    @output = output
  end

  def run
    target.prompt
    catch(:exit_app_loop) do
      run_loop
    end
  end
  
  def app=(value)
    @app = value
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
  

  def private_output
    @output
  end  # for now, until game knows about CommmandHandler
  
  def private_input
    @input
  end  # for now, until game knows about CommmandHandler
  

  private
  
  def target
    @game || @app
  end

  def run_loop
    loop do
      handle_command(user_input)
      target.prompt
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
