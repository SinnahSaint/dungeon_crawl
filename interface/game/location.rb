class Location
  attr_reader :x, :y, :back

  def initialize(x:, y:, back: "")
    @x, @y = x, y
    @back = back[0,1].downcase  # makes sure if someone typed "SOUTH" it gets saved as "s"
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
