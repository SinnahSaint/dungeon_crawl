class Game


  def to_h
    {
      avatar: @avatar.to_h,
      map: @current_map.to_h,
    }
  end
end