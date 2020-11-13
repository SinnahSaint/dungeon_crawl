require 'utility.rb'

RSpec.describe "English List" do
  subject { Utility.english_list(array) }
  
  context "with no words in the array" do
    let(:array) { %w[] }

    it { is_expected.to eq("") }
  end

  context "with one word in the array" do
    let(:array) { %w[one] }

    it { is_expected.to eq("one") }
  end

  context "with two words in the array" do
    let(:array) { %w[one two] }

    it { is_expected.to eq("one and two") }
  end

  context "with three words in the array" do
    let(:array) { %w[one two three] }

    it { is_expected.to eq("one, two, and three") }
  end

  context "with nine words in the array" do
    let(:array) { %w[one two three four five six seven eight nine] }

    it { is_expected.to eq("one, two, three, four, five, six, seven, eight, and nine") }
  end

  context "with three numbers in the array" do
    let(:array) { [1, 2, 3] }

    it { is_expected.to eq("1, 2, and 3") }
  end
end










# class TextBlockTest < Test::Unit::TestCase
  
#   def test_text_block
#     File.open("./files/text_blocks/test.txt",'w') do |file|
#       file.write "This is a test file.\n"
#       file.write "Nothing to see here."
#     end
      
#     assert_equal " "*27 + "This is a test file." + " "*27 + "\n" +
#                " "*27 + "Nothing to see here." + " "*27, 
#                Utility.text_block("test")
    
#     File.delete("./files/text_blocks/test.txt")    
#   end

# end










# class EncounterStub
#   attr_accessor :state, :blocking
  
#   def initialize
#     @blocking = false
#     @state =  "There's a huge pile of rocks. It kind of reminds you of the Alpine Mountains."  
#   end
# end

# class RoomLikeStub
#   attr_accessor :lay, :enc, :inventory, :description
  
#   def initialize
#     @lay = %w[east south west]
#     @enc = EncounterStub.new        
#     @inventory = %w[gemstone stone]
#     @description = "A dusty room full of rubble. "
#   end
# end
  
# class AvatarStub
#   attr_accessor :inventory, :back, :location
  
#   def initialize
#     @inventory = %w[lint penny]
#     @back = "south"
#     @location = [2, 2]
#   end
# end





# class DebugTest < Test::Unit::TestCase

#   def setup
#     @current_room = RoomLikeStub.new
#     @avatar = AvatarStub.new
#   end

#   def test_debug
#     expected =<<~HERE
#     #{"- " * 20}
#     #{"- " * 20}
#     room description: A dusty room full of rubble. 
#     room inventory: gemstone, stone
#     room layout: east, south, west
#     room enc: EncounterStub
#     enc blocking: false
#     enc state: There's a huge pile of rocks. It kind of reminds you of the Alpine Mountains.
#     #{"- " * 20}
#     avatar inventory: lint, penny
#     back direction: south
#     avatar location: 2, 2
#     #{"- " * 20}
#     #{"- " * 20}
#     HERE
    
#     assert_equal expected, Utility.debug(@current_room, @avatar)
#   end
# end