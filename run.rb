require_relative 'app/game.rb'


class App
  
  def run
    Game.new.run
    #Game.new(map_file: './maps/in_and_out.yaml').run
  end
  
  
end







App.new.run

