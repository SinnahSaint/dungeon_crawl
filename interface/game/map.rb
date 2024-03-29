require_relative "./room"
Dir["./encounters/*.rb"].each do |file_name|
  require file_name
end

class Map
  attr_reader :level, :start, :win, :text, :current_location, :options

  def initialize(level: nil, start: nil, win: nil, text: nil, current_location: nil)
    @level = level
    @start = start
    @win = win
    @text = text
    @current_location = current_location || @start
  end
  
  def current_room
     @level[@current_location.y][@current_location.x]
  end

  def current_description
    current_room.current_description
  end

  def blocked?(direction)
    current_room.blocked? && direction != @current_location.back
  end

  def options
    words = {
      "n" => "north",
      "s" => "south",
      "e" => "east",
      "w" => "west",
      "u" => "up",
      "d" => "down",
     }
    current_room.doors.keys.map { |k| words[k] }
  end

  def get_door(direction)
    current_room.doors[direction]
  end

  def follow_door(door)
    @current_location = door.destination
    if @current_location == @win
     nil
    else
      "You step through the door."
    end
  end

  def to_h
    {
      text: @text,
      start: @start.to_h,
      win: @win.to_h,
      current: @current_location.to_h,
      level: @level.map do |row|
        row.map do |room|
          room&.to_h
        end
      end
    }
  end

end
