require 'interface/game_loader.rb'

RSpec.describe "Game Loader" do
  let(:input) { StringIO.new }
  let(:output) { StringIO.new }
  let(:game) { double("game", run: "run successful") }
  let(:ui) { double("ui", input: input, output: output, game: game) }
  
  subject { GameLoader.new(ui: ui) }
  allow(subject).to receive(:save_dir).and_return('spec/files')
  allow(subject).to receive(:new_game_dir) { 'spec/files' }
  # same thing with diff syntax

  
end