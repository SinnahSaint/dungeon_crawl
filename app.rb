require_relative 'app/game.rb'
require_relative "app/utility.rb"
require_relative 'app/user_interface.rb'

class App  
  def initialize(ui: UserInterface.new)
    @ui = ui
    @ui.app = self
  end
    
  def run
    @ui.output Utility.text_block("menu")
    @ui.run
  end
  
  def has_game?
    @game.nil? == false
  end
  
  def prompt
    @ui.output Utility.text_block("menu_prompt")
  end
  
  def boss_emergency
    @ui.output Utility.text_block("boss_emergency")
    throw(:exit_app_loop)
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
  
  def set_and_run_the_game
    @ui.game = @game
    @game.run
    @game = nil
    @ui.game = nil
  end

  def load_save(file: nil)
    if saves_available.include?(file)
      @game = Game.new(ui: @ui)
      @game.load_game(file)
      set_and_run_the_game
    else
      @ui.output "Invalid save name '#{file}'. Nothing happens."
      @ui.output "Please choose among the available save files:\n#{Utility.english_list(saves_available)}" 
    end
  end
  
  def yaml_map_files
    Dir["./maps/*.yaml"]
  end
  
  def random_map
    @maps_avail = yaml_map_files.map(&:to_s)
    # @maps_avail = yaml_map_files.map { |map_name| map_name.to_s }   ## same thing
    
    @maps_avail.sample
  end

  def new_game
    @game = Game.new(ui: @ui, 
                     map_file: random_map,
                     )
    set_and_run_the_game
  end
  
  def quit
    @ui.output "Are you sure you want to quit?"
    if @ui.user_input == "yes"
      @ui.output Utility.text_block("goodbye")
      throw :exit_app_loop 
    else
      return
    end
  end
  
end

