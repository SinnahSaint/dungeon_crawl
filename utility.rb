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
  
  
  module_function :english_list
end