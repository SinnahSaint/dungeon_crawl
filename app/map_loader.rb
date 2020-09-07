require_relative "./location"

class MapLoader
  def initialize(hash)
    @hash = hash
  end
  
  def generate
    level, start, win, text = @hash["map"].values_at(*%w[level start win text])
        
    {
      level: level.map do |row|
        row.map do |col|
          encounter_name = col["encounter"] || "NoEnc"
          Room.new(
            layout: decode_layout(col["layout"]), 
            encounter: Object.const_get(encounter_name).new, 
            inventory: col["inventory"], 
            description: col["description"]
          )
        end
      end,
      start: [Location.new(x: start["x"], y: start["y"]), start["back"]],
      win: [ win["y"], win["x"] ],
      text: text
    }
  end
  
  private
  
  def decode_layout(layout_string)
    layout_string.downcase.to_sym
  end
  
end