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
  
  def text_block(file_name)
    file = "./files/text_blocks/" + file_name + ".txt"
    
    File.open(file, 'r') do |text|
     text.read.lines.map { |line| line.strip.center(74) }.join("\n")
    end
  end
  
  module_function :english_list, :text_block
end
