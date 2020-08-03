require 'test/unit'
Dir["./tests/*.rb"].each do |file_name|
  require_relative file_name
end
