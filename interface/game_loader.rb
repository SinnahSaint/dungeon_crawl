 class GameLoader
  SAVE_DIR = './files/save_games/'

  def initialize(ui: nil)
    @ui = ui
  end

  def new_game
    load_game_from_file(random_map_path)
    @ui.game.run
  end

  def load_saved_game(save_name)
    if saves_available.include?(save_name)
      load_game_from_file(build_save_path(save_name))
      @ui.output "Loaded #{save_name} sucessfully!"   
      @ui.game.run
    else
      @ui.output "Invalid save name '#{save_name}'. Nothing happens."
      @ui.output "Please choose among the available save files:\n#{Utility.english_list(saves_available)}" 
    end
  end

  def load_game_from_file(file_path)    
    return "No such file" unless File.exist? file_path
    
    File.open(file_path, "r") do |data|
      save_hash = YAML.load(data, symbolize_names: true)
    
      current_map = generate_map(save_hash[:map])
      avatar = generate_avatar(save_hash[:avatar])
                          
      @ui.game = Game.new(avatar: avatar, map: current_map, ui: @ui)
    end
  end

  def generate_map(map_hash)
    text, start, win, current, level = map_hash.values_at(
      *%i[text start win current level]
    )

    current = start if current.nil?
        
    Map.new({
      level: level.map do |row|
        row.map do |col|
          encounter = col[:encounter] || { :type => "NoEnc" }
          encounter_type = encounter[:type]
          encounter_params = encounter[:params] || {}
          Room.new(
            encounter: Object.const_get(encounter_type).new(encounter_params), 
            inventory: Inventory.new(col[:inventory]),
            description: col[:description],
            doors: col[:doors].transform_values do |door_hash|
              Door.new(door_hash)
            end,
          )
        end
      end,
      current_location: Location.new(current),
      start: Location.new(start),
      win:  Location.new(win),
      text: text,
    })
  rescue => e
    puts map_hash[:text]
    raise
  end

  def generate_avatar(avatar_hash)
    Avatar.new(avatar_hash)
  end

  def save_to_file(save_filename)
    FileUtils.mkdir_p(SAVE_DIR) unless File.directory?(SAVE_DIR)
  
    File.open(save_filename, 'w') do |file|
      file.write(YAML.dump(save_state))
    end
  end
  
  def save_state
    @ui.game.to_h
  end
  
  def yaml_map_files
    Dir["./files/new_games/*.yaml"]
  end
  
  def random_map_path
    @maps_avail = yaml_map_files.map(&:to_s)
    # @maps_avail = yaml_map_files.map { |map_name| map_name.to_s }   ## same thing
    
    @maps_avail.sample
  end

  def yaml_save_files
    Dir["#{SAVE_DIR}*.yaml"]
  end
  
  def saves_available
    @saves_avail = []
    yaml_save_files.each do |save_name|
      @saves_avail << File.basename(save_name, ".yaml")
    end
    @saves_avail
  end

  def build_save_path(save_name)
    if /\A[a-z0-9_\-]+\z/ =~ save_name
      "#{SAVE_DIR}/#{save_name}.yaml"
    else
      @ui.output "Invalid save name '#{save_name}'. Nothing happens." 
    end
  end
end