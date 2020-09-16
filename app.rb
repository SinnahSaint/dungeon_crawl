require_relative 'app/game.rb'
require_relative "app/utility.rb"


class App
  
  def initialize
    puts Utility.text_block("menu")
    Game.new.run
  end
  
end







App.new

