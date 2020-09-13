require_relative "./room"
Dir["../encounters/*.rb"].each do |file_name|
  require_relative file_name
end

class Map
  attr_reader :level, :start, :win, :text

  def initialize(level: nil, start: nil, win: nil, text: nil)
    @level = level
    @start = start
    @win = win
    @text = text
  end
  
  def to_h
    {
      start: @start,
      win: @win,
      level: @level.map do |row|
        row.map do |room|
          room&.to_h
        end
      end
    }
  end

end
