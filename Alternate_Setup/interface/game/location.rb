class Location
  attr_reader :x, :y, :back

  def initialize(x:, y:, :back = nil)
    @x, @y, @back = x, y, back
  end

  def ==(other)
    x == other.x && y == other.y
  end

  def to_h
    {
      x: @x,
      y: @y,
      back: @back
    }
  end

end
