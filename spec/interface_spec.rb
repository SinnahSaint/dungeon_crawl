require 'interface.rb'

RSpec.describe "Interface" do

  subject { UserInterface.new(input: input, output: output) }
  let(:input) { StringIO.new }
  let(:output) { StringIO.new }

  it { is_expected.to be_an_instance_of(UserInterface) }

  it "it creates the correct collaborators" do
    expect(subject.game).to be_an_instance_of(GameNull)
    expect(subject.game_loader).to be_an_instance_of(GameLoader)
  end

  {
    "" => :missing_command,
    "new" => :start_a_game,
    "save" => :save_the_game,
    "load" => :load_a_game,
    "quit" => :quit,
    'exit' => :quit,
    "!" => :boss_emergency,
    "help" => :help,
    '?' => :help,
  }.each do |command, method|
    it "calls #{method} on UI when told to handle '#{command}'" do
      expect(subject).to receive(method).exactly(1).times
      subject.handle_command(command)
    end
  end

  context "with a null game" do
    %w[ debug debuggame teleport hint inventory i inv look take drop
        equip unequip N E S W U D north east south west up down
        unsupported_command
    ].each do |command|
      it "calls missing_command on UI when told to handle '#{command}'" do
        expect(subject).to receive(:missing_command).exactly(1).times
        subject.handle_command(command)
      end
    end
  end

  context "with a real game" do
    before(:each) do
      fake = double("game", current_room: nil, avatar: nil)
      
      # fake = double("game")
      # allow(fake).to receive(:current_room)
      # allow(fake).to receive(:avatar)
      
      subject.game = fake
    end

    {
      "debug" => :debug,
      "debuggame" => :debug_game,
      "teleport" => :teleport,
      "hint" => :hint,
      "inventory" => :check_avatar_inventory,
      "i" => :check_avatar_inventory,
      "inv" => :check_avatar_inventory,
      "look" => :check_room_inventory,
      "take" => :move_item,
      "drop" => :move_item,
      "equip" => :equip,
      "unequip" => :unequip,
      "north" => :attempt_to_walk,
      "n" => :attempt_to_walk,
      "east" => :attempt_to_walk,
      "e" => :attempt_to_walk,
      "south" => :attempt_to_walk,
      "s" => :attempt_to_walk,
      "west" => :attempt_to_walk,
      "w" => :attempt_to_walk,
      "up" => :attempt_to_walk,
      "u" => :attempt_to_walk,
      "down" => :attempt_to_walk,
      "d" => :attempt_to_walk,
      "unsupported command" => :check_with_encounter
    }.each do |command, method|
      it "calls #{method} on game when told to handle '#{command}'" do        
        # MOCK
        expect(subject.game).to receive(method).exactly(1).times
        subject.handle_command(command)
      end
    end
  end

end