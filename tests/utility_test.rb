require 'test/unit'
require_relative '../utility.rb'

class UtilityTest < Test::Unit::TestCase
  
  def test_english_list_of_none
    array = %w[]
    assert Utility.english_list(array) == ""
  end

  def test_english_list_of_one
    array = %w[one]
    assert Utility.english_list(array) == "one" 
  end

  def test_english_list_of_two
    array = %w[one two]    
    assert Utility.english_list(array) == "one and two"     
  end
  
  def test_english_list_of_three
    array = %w[one two three]  
    assert Utility.english_list(array) == "one, two, and three"      
  end
  
  def test_english_list_of_nine
    array = %w[one two three four five six seven eight nine]  
    assert(Utility.english_list(array)) == "one, two, three, four, five, six, seven, eight, and nine"    
  end
  
  def test_english_list_of_numbers
    array = [1, 2, 3, 4]
    assert Utility.english_list(array) == "1, 2, 3, and 4"
  end

  # def teardown
  # end

  def test_fail
    assert(false, 'Assertion was false.')
  end
end