require 'test/unit'

$LOAD_PATH.unshift('.')

Dir["./tests/*.rb"].each do |file_name|
  require file_name
end
