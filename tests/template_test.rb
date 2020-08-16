require 'test/unit'
require_relative '../template.rb'
require_relative '../encounters/no_enc.rb'
require_relative '../encounters/fire.rb'


class TemplateTest < Test::Unit::TestCase

  def test_init_nada
    nada = Template.new
    assert nada.inventory.empty?
    assert nada.description.empty?
  end

  def test_init_allada
    allada = Template.new(encounter: ->{Fire.new}, inventory: ["knife"], description: "OMG it's aflame!")
    assert_equal allada.inventory, ["knife"]
    assert_equal allada.description, "OMG it's aflame!"
  end

  def test_build_encounter
    lambda_called = false
    test_lambda = ->{ lambda_called = true }
    building = Template.new(encounter: test_lambda)
    
    building.build_encounter
    assert lambda_called
  end
end
