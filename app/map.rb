require_relative "./room"
Dir["../encounters/*.rb"].each do |file_name|
  require_relative file_name
end

class Map
  attr_reader :level, :start, :win
    #
  # TEMP = {
  #   a: Template.new(encounter: ->{Avalanche.new}, inventory:["gemstone"], description: "A dusty room full of rubble. "),
  #   c: Template.new(encounter: ->{Cow.new}, description: "A mostly empty room with straw on the floor. "),
  #   f: Template.new(encounter: ->{Fire.new}, inventory: ["knife"], description: "A kitchen with a nice table. "),
  #   i: Template.new(encounter: ->{Ice.new}, description: "This room is really cold for no good reason. "),
  #   j: Template.new(encounter: ->{Jester.new}, description: "A throne room, with no one on the throne. "),
  #   k: Template.new(encounter: ->{Killer.new}, description: "This room looks like you walked into a bandit's home office. "),
  #   g: Template.new(inventory:["gold"], description: "A lovely room filled with gold. "),
  #   n: Template.new(description: "A literally boring nothing room. "),
  # }.freeze
  #

  def initialize(level: nil, start: nil, win: nil)
    @level = level
    @start = start
    @win = win
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
