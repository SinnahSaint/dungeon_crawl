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


RSpec.describe "Text Block" do
  before do
    File.open("./files/text_blocks/test.txt",'w') do |file|
      file.write "This is a test file.\n"
      file.write "Nothing to see here."
    end
  end

  it "correctly formats the file" do
    formatted_file = " "*27 + "This is a test file." + " "*27 + "\n" +
                      " "*27 + "Nothing to see here." + " "*27

    expect { Utility.text_block("test").to eq formatted_file }   
  end

  after do
    File.delete("./files/text_blocks/test.txt")    
  end
end


RSpec.describe "Debug" do
  before do
    encounter = double("encounter", { blocking: false,
                                  state: "There's a huge pile of rocks. It kind of reminds you of the Alpine Mountains."
                                  })
    current_room = double("current_room", { lay: %w[east south west],
                                        enc: encounter,        
                                        inventory: %w[gemstone stone],
                                        description: "A dusty room full of rubble. " 
                                        })
    avatar = double("avatar", inventory: %w[lint penny] )
  end

  it "outputs the expected text" do
    expected_output =<<~HERE
    #{"- " * 20}
    #{"- " * 20}
    room description: A dusty room full of rubble. 
    room inventory: gemstone, stone
    room layout: east, south, west
    room enc: encounter
    enc blocking: false
    enc state: There's a huge pile of rocks. It kind of reminds you of the Alpine Mountains.
    #{"- " * 20}
    avatar inventory: lint, penny
    #{"- " * 20}
    #{"- " * 20}
    HERE
      
    expect { Utility.debug(current_room, avatar).to eq expected_output }
  end
end
