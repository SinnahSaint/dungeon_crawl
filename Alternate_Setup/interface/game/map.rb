require_relative "./room"
Dir["./encounters/*.rb"].each do |file_name|
  require file_name
end

class Map
  attr_reader :level, :start, :win, :text, :current_location

  def initialize(level: nil, start: nil, win: nil, text: nil, current_location: nil)
    @level = level
    @start = start
    @win = win
    @text = text
    @current_location = current_location || @start
  end
  
  def move(new_location)
    @current_location = new_location
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
