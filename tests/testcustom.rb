require 'test_helper'

# tests the customization of Log4r levels
class TestCustom < TestCase
  include Log4r

  def test_validation
    assert_raise(TypeError) { Configurator.custom_levels "lowercase" }
    assert_raise(TypeError) { Configurator.custom_levels "With space" }
  end

  def test_create
    assert_nothing_raised { Configurator.custom_levels "Foo", "Bar", "Baz" }
    assert_nothing_raised { Configurator.custom_levels }
    assert_nothing_raised { Configurator.custom_levels "Bogus", "Levels" }
  end
#  def test_methods
#    l = Logger.new 'custom1'
#    assert_respond_to(l, :foo)
#    assert_respond_to(l, :foo?)
#    assert_respond_to(l, :bar)
#    assert_respond_to(l, :bar?)
#    assert_respond_to(l, :baz)
#    assert_respond_to(l, :baz?)
#    assert_nothing_raised { Bar }
#    assert_nothing_raised { Baz }
#    assert_nothing_raised { Foo }
#  end

end
