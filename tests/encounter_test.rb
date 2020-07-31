require 'test/unit'
require 'ostruct'
Dir["../encounters/*.rb"].each do |file_name|
  require_relative file_name
end

class EncounterTest < Test::Unit::TestCase
  # def setup
  # end

  # def teardown
  # end

  def test_
    omit("there's no tests here")
  end
end