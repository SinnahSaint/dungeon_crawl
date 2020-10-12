 class GameLoader
  SAVE_DIR = './files/save_games'

  def initialize(ui: nil)
    @ui = ui
  end

  def new_game
    load_game_from_file(random_map_path)
    @ui.game.run
  end

  def save_the_game(save_name)
    save_to_file(build_save_path(save_name))
  end

  def load_saved_game(save_name)
    if saves_available.include?(save_name)
      load_game_from_file(build_save_path(save_name))
      @ui.output "Loaded #{save_name} sucessfully!"
      @ui.game.run
    else
      @ui.output "Invalid save name '#{file}'. Nothing happens."
      @ui.output "Please choose among the available save files:\n#{Utility.english_list(saves_available)}"
    end
  end

  def load_game_from_file(file_path)
    return "No such file" unless File.exist? file_path

    save_hash = YAML.load_file(file_path)

    current_map = generate_map(save_hash["map"])
    avatar = generate_avatar(save_hash["avatar"])

    @ui.game = Game.new(avatar: avatar, current_map: current_map)
  end

  def generate_map(map_hash)
    text, start, win, current, level = map_hash.values_at(
      *%w[text start win current level]
    )

    Map.new({
      level: level.map do |row|
        row.map do |col|
          encounter = col["encounter"] || { "type" => "NoEnc" }
          encounter_type = encounter["type"]
          encounter_params = encounter["params"] || {}
          Room.new(
            encounter: Object.const_get(encounter_type).new(encounter_params),
            inventory: col["inventory"],
            description: col["description"],
            doors: col["doors"].transform_values { |door_hash| Door.new(door_hash) }
          )
        end
      end
      current: Location.new(current.transform_keys(&:to_sym))
      start: Location.new(start.transform_keys(&:to_sym))
      win:  Location.new(win.transform_keys(&:to_sym))
      text: text
    })
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
    Dir["./saves/*.yaml"]
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
