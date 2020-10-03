require 'test/unit'
require 'stringio'
require_relative '../app.rb'

class AppTest < Test::Unit::TestCase
  
  def setup
    @output = StringIO.new
    @input = StringIO.new
    @ui = UserInterface.new(input: @input, output: @output)
    @app = App.new(ui: @ui)
  end
  
  def test_run
    # test by faking input inside the loop to prevent NIL.chomp
    @input.string = "quit\nyes\n"
    @app.run
    assert_match /Welcome to Dungeon Crawl!/, @output.string  # match regex
    assert_match "- -   MAIN MENU   - -", @output.string      # match string
  end
  
  def test_run_2
    # test without faking input by preventing the loop to prevent NIL.chomp
    def @ui.run_loop
      throw :exit_app_loop
    end
    @app.run
    assert_match /Welcome to Dungeon Crawl!/, @output.string  # match regex
    assert_match "- -   MAIN MENU   - -", @output.string      # match string
  end
    
  def test_saves_available
    def @app.yaml_save_files
      ["./saves/one.yaml", "./saves/two.yaml", "./saves/three.yaml"]
    end
    
    expected = ["one", "two", "three"]
    assert_equal expected, @app.saves_available
  end
  
  def test_load_save_empty
    @app.load_save    # no file supplied
    assert_match "Nothing happens", @output.string
    assert_match "Please choose", @output.string
    assert_equal false, @app.has_game?
  end

  def test_load_save_wrong
    @app.load_save(file: "not_really_a_file_for_load_save_test")    # non existant fake file
    assert_match "Nothing happens", @output.string
    assert_match "Please choose", @output.string
    assert_equal false, @app.has_game?
  end

  def test_load_save_right
    def @app.set_and_run_the_game; end
    
    @game = Game.new(ui: @ui)
    @game.save_game("load_save_test_file")
    
    @app.load_save(file: "load_save_test_file")  # with the load_save_test_file

    refute_match /othing happens/, @output.string
    refute_match /lease choose/, @output.string
    assert_equal true, @app.has_game?
    
    File.delete("./saves/load_save_test_file.yaml")
  end
  
  def test_random_map_is_in_list
    maps_array = ["./maps/one.yaml", "./maps/two.yaml", "./maps/three.yaml"]
    @app.define_singleton_method :yaml_map_files do
      maps_array
    end
   
    assert maps_array.include?(@app.random_map), "result not in list provided"
  end
  
  def test_random_map_is_random
    maps_array = ["./maps/one.yaml", "./maps/two.yaml", "./maps/three.yaml"]
    @app.define_singleton_method :yaml_map_files do
      maps_array
    end
    
    counts = Hash.new { 0 }   # initiallizes hash with default value 0 instead of nil
    
    3000.times { counts[@app.random_map] += 1 }
    
    # 3000.times {              # a messier way that would be used in other languages
    #   m = @app.random_map
    #   if counts.has_key?(m)
    #     counts[m] += 1
    #   else
    #     counts[m] = 1
    #   end
    # }
    
    counts.each do |k, v| 
      # assert_in_delta(goal, actual, variation allowed, error msg)
      assert_in_delta(1000, v, 100, "#{k} appeared #{v} times. That is out of happy range.")
    end
  end
  
  def test_quit_empty
    @input.string = "\n"
    catch(:exit_app_loop) do
      @app.quit
    end
    refute_match /GNU General Public License/, @output.string
    assert_equal "Are you sure you want to quit?\n", @output.string
  end
  
  def test_quit_garbage
    @input.string = "kjbsdf asdflkjhas \n"
    @app.quit
    refute_match /GNU General Public License/, @output.string
    assert_equal "Are you sure you want to quit?\n", @output.string
  end
  
  def test_quit_yes
    @input.string = "yes\n"
      catch(:exit_app_loop) do
        @app.quit
      end
    assert_match /GNU General Public License/, @output.string
  end
  
end