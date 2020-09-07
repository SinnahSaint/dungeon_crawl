require_relative "./template"
require_relative "./room"
Dir["../encounters/*.rb"].each do |file_name|
  require_relative file_name
end


class Map
  attr_reader :level, :start, :win
  
  TEMP = {
    a: Template.new(encounter: ->{Avalanche.new}, inventory:["gemstone"], description: "A dusty room full of rubble. "),
    c: Template.new(encounter: ->{Cow.new}, description: "A mostly empty room with straw on the floor. "),
    f: Template.new(encounter: ->{Fire.new}, inventory: ["knife"], description: "A kitchen with a nice table. "),
    i: Template.new(encounter: ->{Ice.new}, description: "This room is really cold for no good reason. "),
    j: Template.new(encounter: ->{Jester.new}, description: "A throne room, with no one on the throne. "),
    k: Template.new(encounter: ->{Killer.new}, description: "This room looks like you walked into a bandit's home office. "),
    g: Template.new(inventory:["gold"], description: "A lovely room filled with gold. "),
    n: Template.new(description: "A literally boring nothing room. "),
  }.freeze
  
  
  LAY = {
    n: %w[north],
    e: %w[east],
    s: %w[south],
    w: %w[west],
    ne: %w[north east],
    ns: %w[north south],
    nw: %w[north west],
    es: %w[east south],
    ew: %w[east west],
    sw: %w[south west],
    nes: %w[north east south],
    new: %w[north east west],
    nsw: %w[north south west],
    esw: %w[east south west],
    nesw: %w[north east south west],
  }.freeze
  
  def initialize(level: nil, start: nil, win: nil)
   @level = level ||[
        [Room.new(LAY[:es], TEMP[:f]), Room.new(LAY[:esw], TEMP[:k]), Room.new(LAY[:w], TEMP[:a])],
        [Room.new(LAY[:ns], TEMP[:n]), Room.new(LAY[:n], TEMP[:g]),   Room.new(LAY[:s], TEMP[:c])],
        [Room.new(LAY[:ne], TEMP[:j]), Room.new(LAY[:esw], TEMP[:n]), Room.new(LAY[:nw], TEMP[:i])],
      ]
    @start = start || [2, 1, "south"] 
    @win = win || [3, 1]
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
