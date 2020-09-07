class Location
  attr_reader :x, :y
  def initialize(x:, y:)
    @x, @y = x, y
  end
  def ==(other)
    x == other.x && y == other.y
  end
  def to_h
    {
      x: x,
      y: y
    }
  end
end