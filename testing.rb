require 'test/unit'

## It's highly unlikely any of the tests pass as 
## they're referencing old code and I haven't updated them.

Dir["./tests/*.rb"].each do |file_name|
  require_relative file_name
end
