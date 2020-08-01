require 'test/unit'
require 'ostruct'
require './player'
Dir["../encounters/*.rb"].each do |file_name|
  require_relative file_name
end

class NoEncTest < Test::Unit::TestCase
  def setup
    @enc = NoEnc.new
  end

  def test_init
    assert_equal @enc.blocking, false
    assert_instance_of Array, @enc.inventory
    assert @enc.inventory.empty?
  end
  
  def test_inventory_manipulation
    @enc.inventory<<"TestItem"
    assert @enc.inventory.include?("TestItem")
    
    @enc.remove_item("TestItem")
    assert @enc.inventory.empty?
  end
  
  def test_handle_command
    assert_equal @enc.handle_command("cmdstr", "avatar"), false
  end
  
  def test_hint
    assert_instance_of String, @enc.hint
    assert_equal @enc.hint.empty?, false 
  end
  
  def test_state
    assert_instance_of String, @enc.state
  end
end

class AvalancheTest < Test::Unit::TestCase
  def setup
    @enc = Avalanche.new
  end

  def test_init
    assert_equal @enc.blocking, false
    assert_instance_of Array, @enc.inventory
    assert @enc.inventory.empty?
  end
  
  def test_inventory_manipulation
    @enc.inventory<<"TestItem"
    assert @enc.inventory.include?("TestItem")
    
    @enc.remove_item("TestItem")
    assert @enc.inventory.empty?
  end
  
  def test_handle_command_yodel
    yell = @enc.handle_command("yodel", "avatar")
    assert_equal yell.empty?, false
    assert_instance_of String, yell  
  end
  
  def test_handle_command_other
    other = @enc.handle_command("this is a test command", "avatar")
    assert_equal other, false    
  end
  
  def test_hint
    assert_instance_of String, @enc.hint
    assert_equal @enc.hint.empty?, false    
  end
  
  def test_state
    assert_instance_of String, @enc.state
    assert_equal @enc.state.empty?, false
    unblocked = @enc.state
    
    @enc.handle_command("yodel", @avatar) # makes blocking true
    
    blocked = @enc.state
    
    assert_not_equal blocked, unblocked
  end
end

class CowTest < Test::Unit::TestCase  
  def setup
    @enc = Cow.new
    @avatar = OpenStruct.new({
      inventory: [],
    })
  end

  def test_init
    assert_equal @enc.blocking, false
    assert_instance_of Array, @enc.inventory
    assert @enc.inventory.empty?
  end
  
  def test_inventory_manipulation
    @enc.inventory<<"TestItem"
    assert @enc.inventory.include?("TestItem")
    
    @enc.remove_item("TestItem")
    assert @enc.inventory.empty?
  end
  
  def test_handle_command_milk
    milk = @enc.handle_command("milk cow", @avatar)
    assert_equal milk.empty?, false
    assert_instance_of String, milk
    assert @avatar.inventory.include?("milk")
  end
  
  def test_handle_command_other  
    other = @enc.handle_command("this is a test command", @avatar)
    assert_equal other, false 
    assert @avatar.inventory.empty?
  end
  
  def test_hint
    assert_instance_of String, @enc.hint
    assert_equal @enc.state.empty?, false
  end
  
  def test_state
    assert_instance_of String, @enc.state
    assert_equal @enc.state.empty?, false
    
    milk = @enc.state
    @enc.handle_command("milk", @avatar) # milk1
    milked = @enc.state
    @enc.handle_command("milk", @avatar) # milk2
    nomilk = @enc.state
    
    assert_equal milk, milked
    assert_not_equal milk, nomilk
    assert_not_equal milked, nomilk
  end
end

class FireTest < Test::Unit::TestCase
  def setup
    @enc = Fire.new
    @avatar = Player.new
  end

  def test_init
    assert_equal @enc.blocking, true
    assert_instance_of Array, @enc.inventory
    assert @enc.inventory.empty?
  end
  
  def test_inventory_manipulation
    @enc.inventory<<"TestItem"
    assert @enc.inventory.include?("TestItem")
    
    @enc.remove_item("TestItem")
    assert @enc.inventory.empty?
  end
  
  def test_handle_command_douse_sucess
    @avatar.inventory<<"milk"
    douse = @enc.handle_command("use milk", @avatar)
    assert_equal douse.empty?, false
    assert_instance_of String, douse
    assert_equal @avatar.inventory.include?("milk"), false
    assert_equal @enc.blocking, false
  end
  
  def test_handle_command_douse_fail
    douse = @enc.handle_command("use milk", @avatar)
    assert_equal douse.empty?, false
    assert_instance_of String, douse
    assert_equal @enc.blocking, true
  end
  
  def test_handle_command_other
    other = @enc.handle_command("this is a test command", @avatar)
    assert_equal other, false 
  end
  
  def test_hint
    assert_instance_of String, @enc.hint
    assert_equal @enc.hint.empty?, false    
  end
  
  def test_state
    assert_instance_of String, @enc.state
    assert_equal @enc.state.empty?, false
    blocked = @enc.state
    
    @avatar.inventory<<"milk"
    douse = @enc.handle_command("use milk", @avatar) # makes blocking false
    
    unblocked = @enc.state
    
    assert_not_equal blocked, unblocked
  end
end

class IceTest < Test::Unit::TestCase  
  def setup
    @enc = Ice.new
    @avatar = Player.new
    def @avatar.called_leave
      @called_leave
    end
    def @avatar.leave(*args)
      @called_leave = true
    end
  end

  def test_init
    assert_equal @enc.blocking, false
    assert_instance_of Array, @enc.inventory
    assert @enc.inventory.empty?
  end
  
  def test_inventory_manipulation
    @enc.inventory<<"TestItem"
    assert @enc.inventory.include?("TestItem")
    
    @enc.remove_item("TestItem")
    assert @enc.inventory.empty?
  end
  
  def test_handle_command_hurry
    @enc.handle_command("hurry", @avatar)
    assert @avatar.called_leave
  end
  
  def test_handle_command_other
    other = @enc.handle_command("this is a test command", @avatar)
    assert_equal other, false 
  end
  
  def test_hint
    assert_instance_of String, @enc.hint
    assert_equal @enc.hint.empty?, false    
  end
  
  def test_state
    assert_instance_of String, @enc.state
    assert_equal @enc.state.empty?, false
  end
end

class JesterTest < Test::Unit::TestCase
  def setup
    @enc = Jester.new
    @avatar = OpenStruct.new({
      inventory: []
    })
  end

  def test_init
    assert_equal @enc.blocking, false
    assert_instance_of Array, @enc.inventory
    assert @enc.inventory.empty?
  end
  
  def test_inventory_manipulation
    @enc.inventory<<"TestItem"
    assert @enc.inventory.include?("TestItem")
    
    @enc.remove_item("TestItem")
    assert @enc.inventory.empty?
  end
  
  def test_handle_command_joke
    joke = @enc.handle_command("tell joke", @avatar)
    assert_equal joke.empty?, false
    assert_instance_of String, joke
    assert @avatar.inventory.include?("laughter")
  end
  
  def test_handle_command_other
    other = @enc.handle_command("this is a test command", @avatar)
    assert_equal other, false
    assert @avatar.inventory.empty?
  end
  
  def test_hint
    assert_instance_of String, @enc.hint
    assert_equal @enc.hint.empty?, false    
  end
  
  def test_state
    assert_instance_of String, @enc.state
  end
end

class KillerTest < Test::Unit::TestCase
  def setup
    @enc = Killer.new
    @avatar = Player.new
    def @avatar.called_leave
      @called_leave
    end
    def @avatar.leave(*args)
      @called_leave = true
    end
  end

  def test_init
    assert_equal @enc.blocking, true
    assert_instance_of Array, @enc.inventory
    assert @enc.inventory.empty?
  end
  
  def test_inventory_manipulation
    @enc.inventory<<"TestItem"
    assert @enc.inventory.include?("TestItem")
    
    @enc.remove_item("TestItem")
    assert @enc.inventory.empty?
  end
  
  def test_handle_command_penny
    bribe = @enc.handle_command("use penny", @avatar)
    assert_equal bribe.empty?, false
    assert_instance_of String, bribe
    assert @avatar.inventory.include?("penny")
    assert @enc.blocking
    
    @avatar.remove_item("penny")
    nopenny = @enc.handle_command("use penny", @avatar)
    assert_equal nopenny.empty?, false
    assert_instance_of String, nopenny
    assert @enc.blocking
  end

  def test_handle_command_milk
    nomilk = @enc.handle_command("give milk", @avatar)
    assert_equal nomilk.empty?, false
    assert_instance_of String, nomilk
    assert @enc.blocking
    # test for friendship in state
    
    @avatar.inventory<<"milk"
    milk = @enc.handle_command("give milk", @avatar)
    assert_equal milk.empty?, false
    assert_instance_of String, milk
    assert @avatar.inventory.none?("milk") 
    assert_equal @enc.blocking, false
    # test for friendship in state
  end

  def test_handle_command_kill
    noknife = @enc.handle_command("kill man", @avatar)
    assert_equal noknife.empty?, false
    assert_instance_of String, noknife
    assert @enc.blocking
    # test for dead in state
    
    @avatar.inventory<<"knife"
    stab = @enc.handle_command("kill man", @avatar)
    assert_equal stab.empty?, false
    assert_instance_of String, stab
    assert @avatar.inventory.none?("knife")
    assert @avatar.inventory.none?("hope")
    assert @avatar.inventory.none?("laughter")  
    assert_equal @enc.blocking, false
    # test for dead in state 
  end

  def test_handle_command_joke
    @enc.handle_command("tell joke", @avatar)
    assert @avatar.called_leave
  end
  
  def test_handle_command_other
    other = @enc.handle_command("this is a test command", @avatar)
    assert_equal other, false 
  end
  
  def test_hint
    assert_instance_of String, @enc.hint
    assert_equal @enc.hint.empty?, false    
  end
  
  def test_state
    assert_instance_of String, @enc.state
    assert_equal @enc.state.empty?, false
    
    @avatar.inventory<<"milk"
    @avatar.inventory<<"knife"
    
    default = @enc.state
    @enc.handle_command("give milk", @avatar) # triggers friend = true 
    friend = @enc.state
    @enc.handle_command("kill man", @avatar) # triggers dead = true
    dead = @enc.state
    
    assert_not_equal default, friend
    assert_not_equal default, dead
    assert_not_equal friend, dead    
  end
end
