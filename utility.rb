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
  

  def debug (current_room, avatar)
    puts "- " * 20
    puts "- " * 20
    puts "room description: #{current_room.description}" 
    puts "room inventory: #{current_room.inventory.join(", ")}"
    puts "room layout: #{current_room.lay.join(", ")}"
    puts "room enc: #{current_room.enc.class}"
    puts "enc blocking: #{current_room.enc.blocking}"
    puts "enc state: #{current_room.enc.state}"
    puts "- " * 20
    puts "avatar inventory: #{avatar.inventory.join(", ")}"
    puts "back direction: #{avatar.back}"
    puts "avatar location: #{avatar.location.join(", ")}"
    puts "- " * 20
    puts "- " * 20
  end
  
  module_function :english_list, :debug
end
