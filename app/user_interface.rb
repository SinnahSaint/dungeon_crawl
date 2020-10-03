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
  
  def handle_command(cmdstr)
  
    if @game    
      first, second, third, fourth = cmdstr.split(" ")  
    
      replacements = {
        'n' => 'north',
        'e' => 'east',
        's' => 'south',
        'w' => 'west',
        'i' => 'inventory',
        'inv' => 'inventory',
        '?' => 'help',
      }
      first = replacements[first] || first
        
      output case first
              when nil
                missing_command
              when "debug"
                @game.debug
              when "debuggame"
                @game.PP.pp(debug_game, "")
              when "teleport"
                @game.teleport(Location.new(y: second.to_i, x: third.to_i), fourth)
              when "north", "east", "south", "west"
                @game.attempt_to_walk(first)
              when "help"
                @game.help
              when "hint"
                @game.hint
              when "inventory"
                @game.check_inventory
              when "quit", "exit"
                @game.quit
              when "take"
                @game.move_item(second, current_room, @avatar, 
                          on_success: "You #{first} the #{second}.",
                          on_fail: "Whoops! There's no #{second} you can take with you here.")
              when "drop"
                @game.move_item(second, @avatar, current_room,
                          on_success: "You #{first} the #{second}.",
                          on_fail: "Whoops! No #{second} in inventory.")
              else
                @game.check_with_encounter(cmdstr)
              end  
    
    else
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
  

  def confused
    @output.puts "I don't understand."
  end
  
end
