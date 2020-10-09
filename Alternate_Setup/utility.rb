module Utility

  def english_list(array)
    case array.size
      when 0 then ""
      when 1 then array.first.to_s
      when 2 then array.join(" and ")
      else 
        last = array.last
        most = array.slice(0, array.size - 1)
        "#{most.join(", ")}, and #{last}"
    end
  end
  
  def debug_game(game)
    game.to_h
  end
  
  def text_block(file_name)
    file = "./text_blocks/" + file_name + ".txt"
    
    File.open(file, 'r') do |text|
     text.read.lines.map { |line| line.strip.center(74) }.join("\n")
    end
  end
  
  def debug(current_room, avatar)
    <<~HERE
    #{"- " * 20}
    #{"- " * 20}
    room description: #{current_room.description}
    room inventory: #{current_room.inventory.join(", ")}
    room layout: #{current_room.lay.join(", ")}
    room enc: #{current_room.enc.class}
    enc blocking: #{current_room.enc.blocking}
    enc state: #{current_room.enc.state}
    #{"- " * 20}
    avatar inventory: #{avatar.inventory.join(", ")}
    back direction: #{avatar.back}
    avatar location: #{avatar.location.join(", ")}
    #{"- " * 20}
    #{"- " * 20}
    HERE
  end
  
  module_function :english_list, :debug, :debug_game, :text_block
end
