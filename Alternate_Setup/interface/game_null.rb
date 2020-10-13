class GameNull
  def initialize(ui)
    @ui = ui
  end
  def current_room
    nil
  end
  def avatar
    nil
  end
  def to_h
    {}
  end
  def method_missing(*args)    
    @ui.missing_command
  end
end
