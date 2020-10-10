 class GameLoader
  SAVE_DIR = './files/save_games'

  def initialize(ui: nil)
    @ui = ui
  end

  def new_game
    create_game(file: random_map)
    set_the_game
    @game.run
  end

  def save_the_game(save_name)
    save_to_file(build_filename(save_name))
  end

  def load_saved_game(file: nil)
    if saves_available.include?(file)
      load_game_from_file(file)
      set_the_game
      @game.run
    else
      @ui.output "Invalid save name '#{file}'. Nothing happens."
      @ui.output "Please choose among the available save files:\n#{Utility.english_list(saves_available)}" 
    end
  end

  def create_game(file: nil)
    @game = Game.new(ui: @ui, map_file: file, avatar: nil, current_map: nil)
  end

  def set_the_game
    @ui.game = @game
  end

  def load_game_from_file(save_name)
    save_filename = build_filename(save_name)
    
    return "No such file" unless File.exist? save_filename
    
    save_hash = YAML.load_file(save_filename)
    @map_file = save_hash[:map_file]
    @current_map = Map.new(generate(save_hash))
    
    avatar_hash = save_hash[:avatar]
    
    @avatar = Avatar.new(
                        inventory: Inventory.new(avatar_hash[:inventory])
                        )
                        
    @current_map.level.each.with_index do |row, y|
      row.each.with_index do |cell, x|
        room_save = save_hash[:level][y][x]
        inv_save = room_save[:inventory]
        enc_params = room_save[:enc]
        
        cell.inventory.replace(inv_save)
        cell.replace_enc(cell.enc.class.new(enc_params))
      end
      create_game(map_file: @map_file, avatar: @avatar, current_map: @current_map)
    end
    @ui.output "Loaded #{save_name} sucessfully!"   
  end

  def yaml_map_files
    Dir["./files/new_games/*.yaml"]
  end
  
  def random_map
    @maps_avail = yaml_map_files.map(&:to_s)
    # @maps_avail = yaml_map_files.map { |map_name| map_name.to_s }   ## same thing
    
    @maps_avail.sample
  end


    

  
  def decode_layout(layout_string)
    layout_string.downcase.to_sym
  end

  def generate(hash)
    level, start, win, text = hash["map"].values_at(*%w[level start win text])
        
    {
      level: level.map do |row|
        row.map do |col|
          encounter_name = col["encounter"] || "NoEnc"
          Room.new(
            doors: col["doors"].map do |k,v|
              Door.new(direction: k, destination: v)
            end
            encounter: Object.const_get(encounter_name).new, 
            inventory: col["inventory"], 
            description: col["description"]
            current_location: col["current_location"]
          )
        end
      end,
      start: [Location.new(x: start["x"], y: start["y"], back: start["back"])],
      win:  Location.new(x: win["x"], y: win["y"] ),
      text: text
    }
  end

    
  def save_to_file(save_filename)
    FileUtils.mkdir_p(SAVE_DIR) unless File.directory?(SAVE_DIR)
  
    File.open(save_filename, 'w') do |file|
      file.write(YAML.dump(save_state))
    end
  end
  
  def save_state
    {
      map_file: @map_file,
      avatar: @avatar.to_h,
      level: @current_map.level.map { |row| row.map { |room| room.save_state } }
    }
  end
  

  
  def build_filename(save_name)
    if /\A[a-z0-9_\-]+\z/ =~ save_name
      "#{SAVE_DIR}/#{save_name}.yaml"
    else
      @ui.output "Invalid save name '#{save_name}'. Nothing happens." 
    end
  end
  




end