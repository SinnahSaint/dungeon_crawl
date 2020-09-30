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
  
  def test_load_save
    
  end
  
  def test_random_map
    
  end
  
  def test_new_game
    
  end
  
  def test_quit
    
  end
  
end