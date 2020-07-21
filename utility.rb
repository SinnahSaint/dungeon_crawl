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

  def teleport(input, back, avatar)
    avatar.location = input.split(",").map { |str| str.to_i }
    avatar.back = back
  end
  
  def debug (current_room, avatar)
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
  
  module_function :english_list, :debug, :teleport
end
