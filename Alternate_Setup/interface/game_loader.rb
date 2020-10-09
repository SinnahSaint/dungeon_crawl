def load_save(file: nil)
    if saves_available.include?(file)
      @game = Game.new(ui: @ui)
      @game.load_game(file)
      set_the_game
      @game.run
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
    set_the_game
    @game.run
  end
  