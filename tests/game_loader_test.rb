require 'test/unit'
require 'ostruct'
require 'stringio'
require 'yaml'

require './interface/game_loader.rb'

class GameLoaderTest < Test::Unit::TestCase

  def setup
    @output = StringIO.new
    @input = StringIO.new
    @ui = OpenStruct.new(input: @input, output: @output)
    @ui.game = OpenStruct.new(run: "run successful")

    @loader = GameLoader.new(ui: @ui)
    def @loader.save_dir
      './tests/testingfiles'
    end
    def @loader.new_game_dir
      './tests/testingfiles'
    end
    
  end

  def test_new_game 
    assert_equal "run successful", @loader.new_game

    # I wanna shortcut the random map path and save path 
    # to avoid actually having to require all encounters and such
  end

  def test_load_saved_game_sucess
    # assert_equal  "run successful", load_saved_game("testfile")
  end

  def test_load_saved_game_failure
    # fail = load_saved_game("file_not_found")
    # refute_equal  "run successful", fail
    # assert_match  "Invalid save name", @output
    # assert_match  "Please choose among", @output
  end

  def test_saves_available
    expected = ["primarytestfile", "secondarytestfile" ]
    real = @loader.saves_available
    assert_equal expected.sort, real.sort
  end

  def test_save_to_file
    @game = @ui.game
    def @game.to_h
    {
      avatar: "Avatar hash",
      map: "Map hash",
    }
    end

    refute @loader.saves_available.include? "gonnasavenow"
    @loader.save_to_file("gonnasavenow")
    assert @loader.saves_available.include? "gonnasavenow"

    file_path = './tests/testingfiles/gonnasavenow.yaml'
    File.open(file_path, "r") do |data|
      @info = YAML.load(data, symbolize_names: true)
    end
    File.delete(file_path)

    expected = {
      avatar: "Avatar hash",
      map: "Map hash",
    }
    assert_equal expected, @info
  end


end