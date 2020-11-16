require 'interface/game_loader.rb'

RSpec.describe "Game Loader" do
  let(:game) { double("game", run: "run successful") }
  let(:ui) { double("ui", game: game) }
  let(:game_loader) { GameLoader.new(ui: ui) }
  subject { game_loader }

  before do
    allow(subject).to receive(:save_game_dir).and_return('spec/files')
    allow(subject).to receive(:new_game_dir) { 'spec/files' }
    # same thing with diff syntax
  end


  context "when loading a save game" do

    context "with a valid save name" do
      let(:save_name) { "primarytestfile" }

      before do
        FileUtils.touch ["spec/files/primarytestfile.yaml"] 
      end

      it "identifies and loads the correct file" do
        expect(subject).to receive(:load_game_from_file).with("spec/files/primarytestfile.yaml")
        expect(ui).to receive(:output).with(/Loaded/)
        expect(subject).to receive(:run_game)

        expect(ui).to_not receive(:output).with(/Invalid save name/)

        subject.load_saved_game(save_name)
      end
  
    end


    context "with a invalid save name" do
      let(:save_name) { "file_not_found" }
      
      it "provides an error msg and does not load a file" do
        expect(ui).not_to receive(:output).with(/run successful/)
        expect(ui).to receive(:output).with(/Invalid save name/)
        expect(ui).to receive(:output).with(/Please choose among/)

        subject.load_saved_game(save_name)
      end
    end
  end

  context "when starting a new game" do
    it "chooses a random file from available options" do
      allow(subject).to receive(:run_game)
      allow(subject).to receive(:load_game_from_file)
      expect(subject).to receive(:random_new_path)
      
      # expect_any_instance_of(Array).to receive(:sample)  
      # I found it but it's not best-practice and it doesn't work so... something else
    end

    it "loads and runs a file" do
      expect(subject).to receive(:load_game_from_file)
      expect(subject).to receive(:run_game)
    end

    after do
      subject.load_new_game
    end
  end

  it "correctly lists saves available" do
    FileUtils.touch [
      "spec/files/primarytestfile.yaml", 
      "spec/files/secondarytestfile.yaml" 
    ]
    expected = ["primarytestfile", "secondarytestfile" ]

    expect(subject.files_available("save")).to match_array(expected)
  end


  let(:savestate) { {
    avatar: "Avatar hash",
    map: "Map hash",
  } }

  it "saves to file" do
    allow(game).to receive(:to_h).and_return savestate

    expect(subject.files_available("save")).not_to include("gonnasavenow")
    subject.save_to_file("gonnasavenow")
    expect(subject.files_available("save")).to include("gonnasavenow")

    info = {}
    file_path = 'spec/files/gonnasavenow.yaml'
    File.open(file_path, "r") do |data|
      info = YAML.load(data, symbolize_names: true)
    end
    
    expect(info).to eq savestate
    
  ensure 
    File.delete(file_path)
  end
end