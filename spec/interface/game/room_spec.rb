require 'interface/game/room.rb'

RSpec.describe "Room" do

  context "room initialized with no args" do
    subject { Room.new }

    it "creates an empty door list" do
      expect(subject.door_list).to be_an_instance_of(Hash)
      expect(subject.door_list).to be_empty
    end

    it "creates the default encounter" do
      expect(subject.enc).to be_an_instance_of(NoEnc)
    end

    it "creates an empty inventory" do
      expect(subject.room_inv).to be_an_instance_of(Inventory)
      expect(subject.room_inv.loot).to be_an_instance_of(Array)
      expect(subject.room_inv.loot).to be_empty

      expect(subject.room_inv.equipment).to be_an_instance_of(Hash)
      proper_keys = %i[head torso feet weapon trinket mood]
      expect(subject.room_inv.equipment.keys).to eq proper_keys
      expect(subject.room_inv.equipment.values.none?).to be(true)
    end

    it "creates empty room description" do
      expect(subject.room_desc).to eq ""
    end

    it "provides the expected output with to_h" do
      output = {:description=>"",
        :doors=>{},
        :encounter=>{:params=>{:blocking=>false}, :type=>"NoEnc"},
        :inventory=>
         {:equipment=>
           {:feet=>nil,
            :head=>nil,
            :mood=>nil,
            :torso=>nil,
            :trinket=>nil,
            :weapon=>nil},
          :loot=>[]}}

      expect(subject.to_h).to eq output
    end
  end

  context "room initialized with custom args" do
      let(:fake_enc) { double("Fire", to_h: "fake fire") }
      let(:fake_doors) { { N: { x: 2, 
                          y: 3, 
                          back: "home"
                        }}}
      let(:fake_inv) { {  loot: ["penny", "lint"], 
                          equipment: { head:"helmet", mood: "hope" }
                        }}
      let(:fake_desc) { "This is a test room." }

    subject do
      Room.new(
                doors: fake_doors, 
                encounter: fake_enc, 
                inventory: fake_inv, 
                description: fake_desc )
    end

    it "creates the provided door list" do
      expect(subject.door_list).to be_an_instance_of(Hash)
      expect(subject.door_list).to eq fake_doors
    end

    it "creates the provided encounter" do
      expect(subject.enc).to be(fake_enc)
    end

    it "creates the provided inventory" do
      expect(subject.room_inv).to be_an_instance_of(Inventory)
      expect(subject.room_inv.loot).to be_an_instance_of(Array)
      expect(subject.room_inv.loot).to eq fake_inv[:loot]

      expect(subject.room_inv.equipment).to be_an_instance_of(Hash)
      proper_keys = %i[head torso feet weapon trinket mood]
      expect(subject.room_inv.equipment.keys).to eq proper_keys
      proper_equip = { feet: nil, head: "helmet", mood: "hope", torso: nil, trinket: nil, weapon: nil }
      expect(subject.room_inv.equipment).to eq proper_equip
    end

    it "creates the provided room description" do
      expect(subject.room_desc).to eq fake_desc
    end

    it "provides the expected output with to_h" do
      output = {:description=>"This is a test room.",
        :doors=>
         {:N=>{:back=>"home", :x=>2, :y=>3}},
        :encounter=>"fake fire",
        :inventory=>
         {:equipment=>
           {:feet=>nil,
            :head=>"helmet",
            :mood=>"hope",
            :torso=>nil,
            :trinket=>nil,
            :weapon=>nil},
          :loot=>["penny", "lint"]}}

      expect(subject.to_h).to eq output
    end
  end

  context "when comparing rooms" do
    let(:default) { Room.new }
    let(:another_default) { Room.new }
    let(:custom) { Room.new(  doors: { N: { x: 2, y: 3, back: "home" }}, 
                              encounter: "fake_enc", 
                              inventory: { loot: ["lint"], equipment: {} }, 
                              description: "fake_desc" ) }

    it "correctly sees different rooms as unequal" do
      expect(custom).not_to eq default
    end
  
    it "correctly sees similar rooms as equal" do
      expect(default).to eq another_default  
    end
  end
end
