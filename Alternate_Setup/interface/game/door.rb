require_relative = '/map.rb'

def class Door
  def initialize (direction: nil, destination: nil)
    @direction = direction
    @destination = Location.new(destination)
  end

  def use_door(door: nil)
    @map.move(door.destination)
  end

end