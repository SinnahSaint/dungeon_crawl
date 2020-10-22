require_relative = '/map.rb'

class Door
  def initialize(destination:, description: nil )
    @destination = Location.new(destination)
    @description = description || "You move to the next room."
  end

  def to_h
    {
      destination: @destination.to_h,
      description: @description
    }
  end
end

