require 'test/unit'
require 'stringio'
require_relative '../app.rb'

class AppTest < Test::Unit::TestCase
  
  def setup
    @output = StringIO.new
    @input = StringIO.new
    @app = App.new(input: @input, output: @output)
  end
  
  def test_init
    assert_equal @input, @app.input
    assert_equal @output, @app.output
  end
  
  def test_user_input
    @input.string = "HeLLo\n"
    assert_equal "hello", @app.user_input

    catch(:exit_app_loop) do
      @input.string = "!\n"
      @app.user_input
      assert false, "Expected :exit_app_loop to throw, but it didn't"
    end
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
    def @app.run_app_loop
      throw :exit_app_loop
    end
    @app.run
    assert_match /Welcome to Dungeon Crawl!/, @output.string  # match regex
    assert_match "- -   MAIN MENU   - -", @output.string      # match string
  end
  
  def test_handle_command
    mappings = {
      "new"     => :new_game,
      "load"    => :load_save,
      "quit"    => :quit,
      ""        => :confused,
      "run"     => :confused,
      ";kad;jn" => :confused,
      "!"       => :boss_emergency,
    }
    
    def @app.call_counts
      @call_counts ||= Hash.new { 0 }
    end

    mappings.values.each do |sym|
      # def @game.teleport(*args)
      #  call_counts[:teleport] += 1
      # end
      @app.define_singleton_method(sym) do |*args|
        call_counts[sym] += 1
      end
    end

    mappings.each do |command, method|
      before = @app.call_counts[method]
      @app.handle_command(command)
      after = @app.call_counts[method]
      assert_equal before + 1, after
    end
  end
  
  def test_saves_available
    def @app.yaml_save_files
      ["./saves/one.yaml", "./saves/two.yaml", "./saves/three.yaml"]
    end
    
    expected = ["one", "two", "three"]
    assert_equal expected, @app.saves_available
  end
  
  def test_load_save_empty
    @app.load_save()    # no file supplied
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
    def @app.run_the_game; end
    
    Game.new.save_game("load_save_test_file")
    
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
  
  
  
  def test_new_game
    
  end
  
  def test_quit
    
  end
  
end