require 'test/unit'
require 'ostruct'
require 'stringio'

require './interface/game_loader.rb'

class GameLoaderTest < Test::Unit::TestCase

  def setup
    @output = StringIO.new
    @input = StringIO.new
    @ui = OpenStruct.new(input: @input, output: @output)
    @ui.game = OpenStruct.new(run: "run successful")
    @loader = GameLoader.new(ui: @ui)

    # I wanna circumvent the yaml_map_files and yaml_save_files
    # to avoid actually having to require all encounters and such
    # gotta ask meg
    
  end

  def test_new_game
    # assert_equal "run successful", @loader.new_game

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
    # assert_equal expected, saves_available
  end

  def test_save_to_file
    # assert saves_available doesn't include "gonnasavenow"
    # save_to_file("gonnasavenow")
    # assert saves_available includes "gonnasavenow"
  end

  def cleanup
    # delete "gonnasavenow" from yaml_save_files
  end

end