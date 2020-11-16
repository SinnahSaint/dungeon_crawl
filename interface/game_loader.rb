require "fileutils"
require 'yaml'

require 'interface/game/location.rb'
require 'interface/game/map.rb'
require 'interface/game/room.rb'
require 'interface/game/avatar.rb'
require 'utility'

 class GameLoader

  def initialize(ui:)
    @ui = ui
  end

  def save_game_dir
    './files/save_games'
  end

  def new_game_dir
    './files/new_games'
  end

  def directory_chooser(dir)
    if dir == "save"
      save_game_dir
    else
      new_game_dir
    end
  end

  def load_new_game
    load_game_from_file(random_new_path)
    run_game
  end

  def load_saved_game(save_name)
    if files_available("save").include?(save_name)
      load_game_from_file(build_file_path("save", save_name))
      @ui.output "Loaded #{save_name} sucessfully!"   
      run_game
    else
      @ui.output "Invalid save name '#{save_name}'. Nothing happens."
      @ui.output "Please choose among the available save files:\n#{Utility.english_list(files_available("save"))}" 
    end
  end

  def files_available(dir)
    @files_avail = []
    yaml_files(dir).each do |file_name|
      @files_avail << File.basename(file_name, ".yaml")
    end
    @files_avail
  end

  def yaml_files(dir)
    Dir["#{directory_chooser(dir)}/*.yaml"]
  end

  def save_to_file(save_name)
    FileUtils.mkdir_p(save_game_dir) unless File.directory?(save_game_dir)
  
    save_path = build_file_path("save", save_name)
    File.open(save_path, 'w') do |file|
      file.write(YAML.dump(save_state))
    end
  end

  def create_game(avatar:, map:)
    @ui.game = Game.new(avatar: avatar, map: map, ui: @ui)
  end

  def run_game
    @ui.game.run
  end

  def load_game_from_file(file_path)    
    return "No such file" unless File.exist? file_path
    
    File.open(file_path, "r") do |data|
      save_hash = YAML.load(data, symbolize_names: true)
    
      current_map = generate_map(save_hash[:map])
      avatar = generate_avatar(save_hash[:avatar])
                          
      create_game(avatar: avatar, map: current_map)
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
            inventory: Inventory.new(loot: col[:inventory]),
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

  def save_state
    @ui.game.to_h
  end
  
  def random_new_path
    @maps_avail = yaml_files("new").map(&:to_s)
    
    @maps_avail.sample
  end

  def build_file_path(dir, file_name)
    if /\A[a-z0-9_\-]+\z/ =~ file_name
      "#{directory_chooser(dir)}/#{file_name}.yaml"
    else
      @ui.output "Invalid file name '#{file_name}'. Nothing happens." 
    end
  end
end