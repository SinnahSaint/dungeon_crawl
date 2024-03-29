require "./interface/game/location.rb"
require_relative = '/map.rb'

class Door
  attr_reader :destination, :description
  def initialize(destination:, description: nil )
    @destination = Location.new(**destination)
    @description = description || "You move to the next room."
  end

  def to_h
    {
      destination: @destination.to_h,
      description: @description
    }
  end
end

