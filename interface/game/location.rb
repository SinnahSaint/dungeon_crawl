class Location
  attr_reader :x, :y, :back

  def initialize(x:, y:, back: nil)
    @x, @y = x, y

    @back = back || ""
    @back = @back[0,1].upcase  # makes sure if someone typed "south" it gets saved as "S"
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
