class Location
  attr_reader :x, :y, :back

  def initialize(x:, y:, back: "")
    @x, @y = x, y
    if back == ""
      @back = back
    else
      @back = back[0].downcase  # makes sure if someone typed "SOUTH" it gets saved as "s"
    end
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
