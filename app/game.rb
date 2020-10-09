require_relative "./player"
require_relative "./room"
require_relative "./map"
require_relative "./utility"
require_relative "./map_loader"
require_relative "./location"
require_relative './game_null'

require 'yaml'
require 'pp'
require 'fileutils'

Dir["./encounters/*.rb"].each do |file_name|
  require file_name
end

class Game
  attr_reader :avatar
  DEFAULT_MAP_FILE = './maps/spiral.yaml'
  SAVE_DIR = './saves'
  
  def initialize(ui: nil, avatar: nil, map: nil, map_file: nil)
    @ui = ui
    @avatar = avatar || Player.new(self)
    @map_file = map_file || DEFAULT_MAP_FILE
    @current_map = Map.new(map || load_map_from_file(@map_file))
    
    location, back = @current_map.start
    @avatar.move(location, back)
  end  
 
  def run
    @ui.output Utility.text_block("intro")
    @ui.output @current_map.text
  end
  
  def new_game
    missing_command
  end

  def load_save
    missing_command
  end
  
  def load_game(save_name)
    save_filename = build_filename(save_name)
    
    return "No such file" unless File.exist? save_filename
    
    save_hash = load_save_from_file(save_filename)
    @map_file = save_hash[:map_file]
    @current_map = Map.new(load_map_from_file(@map_file))
    
    avatar_hash = save_hash[:avatar]
    
    @avatar = Player.new(
                        self, 
                        location: Location.new(avatar_hash[:location]), 
                        back: avatar_hash[:back], 
                        inventory: avatar_hash[:inventory]
                        )
                        
    @current_map.level.each.with_index do |row, y|
      row.each.with_index do |cell, x|
        room_save = save_hash[:level][y][x]
        inv_save = room_save[:inventory]
        enc_params = room_save[:enc]
        
        cell.inventory.replace(inv_save)
        cell.replace_enc(cell.enc.class.new(enc_params))
      end
    end
    @ui.output "Loaded #{save_name} sucessfully!"   
  end
  
  def game_over(msg)
    @ui.game = GameNull.new(@ui)
    msg
  end
  
  def boss_emergency
    time = Time.now
    save_game("boss_emergency_#{time.day}#{time.hour}")
    @ui.output(Utility.text_block("boss_emergency"))
    throw(:exit_app_loop)
  end
  
  def load_map_from_file(filename)
    MapLoader.new(YAML.load_file(filename)).generate
  end
  
  def to_h
    {
      avatar: @avatar.to_h,
      current_map: @current_map.to_h
    }
  end
    
  def prompt
    look
    @ui.output "- " * 20
    @ui.output "What's next? > "
  end

  def current_room
    @current_map.level[@avatar.location.y][@avatar.location.x]
  end
 
  def check_inventory
    unless @avatar.inventory.empty?
      lines = @avatar.inventory.map { |item| " * #{item}" }.join("\n")
      "Your inventory includes: \n#{lines} "
    else
      "You're not carrying anything."
    end
  end

  def attempt_to_walk(nesw)
    return "That's a wall dummy." unless current_room.lay.include? nesw
    
    update = { 
      "north" => [Location.new(y: @avatar.location.y - 1, x: @avatar.location.x + 0), "south"],
      "east"  => [Location.new(y: @avatar.location.y + 0, x: @avatar.location.x + 1), "west"],
      "south" => [Location.new(y: @avatar.location.y + 1, x: @avatar.location.x + 0), "north"],
      "west"  => [Location.new(y: @avatar.location.y + 0, x: @avatar.location.x - 1), "east"],
      }
    
    if @avatar.back == nesw
      move_avatar(*update.fetch(nesw))
    elsif current_room.enc.blocking 
      "You'll have to deal with this or go back."
    else
      move_avatar(*update.fetch(nesw))
    end
  end
  
  def move_avatar(location, back)
    @avatar.move(location, back)
    if @avatar.location == @current_map.win
      game_over("You Win!\nYou manage to leave alive. Huzzah!\n #{check_inventory}")
    else
      "You walk to the next room."
    end
  end

  def move_item(item,from,to, on_success: nil, on_fail: nil)
    on_fail ||= "Missing item #{item}"
    raise on_fail unless from.inventory.include?(item)
    
    from.remove_item(item)
    to.inventory << item
    
    on_success || "Moved #{item}"
  end
  
  def quit
    @ui.output "Would you like to save before you quit?"
    save_request = @ui.user_input
      
    if save_request == "yes"
      catch (:save_sucess) do
        loop do
          @ui.output "Please type a simple name for your save file."
          @save_name = @ui.user_input
          if save_game(@save_name) then throw(:save_sucess) end
        end
      end
      game_over("Saved #{@save_name} successfully.")
    elsif save_request == "no"
      game_over("You give up! No loot for you. Game Over!")
    else 
      @ui.output "Simple yes or no please."
      quit
    end
    
  end
  
  def save_game(save_name)
    save_to_file(build_filename(save_name))
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
  
  def load_save_from_file(save_filename)
    YAML.load_file(save_filename)
  end
  
  def build_filename(save_name)
    if /\A[a-z0-9_\-]+\z/ =~ save_name
      "#{SAVE_DIR}/#{save_name}.yaml"
    else
      @ui.output "Invalid save name '#{save_name}'. Nothing happens."
      quit 
    end
  end
  
  def check_with_encounter(cmdstr)
   result = current_room.enc.handle_command(cmdstr, @avatar)
   unless result
    result = "Trying to #{cmdstr} won't work right now."
   end
   result
  end
  
  def teleport(location, back)
    raise "RTFM Shannon" if back.nil?
    move_avatar(location, back)
    "BANFF"
  end
  
  def help
    Utility.text_block("help")
  end

  def hint
    current_room.enc.hint
  end 
  
  def debug
    Utility.debug(current_room, @avatar)
  end
  
  def debug_game
    Utility.debug_game(self)
  end
  
  def look
    @ui.output current_room.description
    @ui.output current_room.enc.state unless current_room.enc.state == ""
    unless current_room.inventory.empty?
      @ui.output "In this room you can see: #{Utility.english_list(current_room.inventory)}"
    else
      @ui.output "You don't see any interesting items here."
    end  
   
    doors = current_room.lay.reject { |dir| dir == @avatar.back }
    
    if @avatar.back.empty? 
      exits = doors.empty? ? "and there are no exits you can see." : "but you can exit to the #{Utility.english_list(doors)}"
      @ui.output "There is no way to go back the way you came, #{exits}"
    else
      exits = doors.empty? ? "#{@avatar.back}" : "#{Utility.english_list(doors)}, or #{@avatar.back}"
      @ui.output "You can exit to the #{exits}, back the way you came."
    end
  end

end
