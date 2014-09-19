require 'test_helper'

class ConfigurationTest < ActiveSupport::TestCase

  def test_has_default_values
    assert_config_default :models
    assert_config_default :colors, [ :light_blue, :blue_green, :red, :yellow, :orange, :purple, :dark_blue, :dark_red, :green ]
  end

  def test_allow_overwrite
    assert_config_overridable :models
    assert_config_overridable :colors
  end

  def assert_config_default(option, default_value = nil)
    config ||= Upmin::Configuration.new
    if default_value.nil?
      assert_not_nil config.send(option)
    else
      assert_equal default_value, config.send(option)
    end
  end

  def assert_config_overridable(option, value = 'a value')
    config = Upmin::Configuration.new
    config.send(:"#{option}=", value)
    assert_equal value, config.send(option)
  end
end