require 'test_helper'

# Define a custom outputter that allows arrays in configuration hash
module Log4r
  class TestYamlOutputter < Outputter
    # expose array parameter
    attr_reader :array_param

    def initialize(name, hash = {})
      @array_param = hash['array_param']
    end
  end
end


class TestYaml < TestCase
  include Log4r

  def setup
    @cfg = YamlConfigurator # shorthand
    @cfg['CUSTOM_DOMAIN'] = 'bar.com'
  end

  def test_injection
    assert_nothing_raised("Exception injected") do
      @cfg.load_yaml_file(File.join(File.dirname(__FILE__),'testyaml_injection.yaml'))
    end
  end

  def test_arrays
    assert_nothing_raised("Parser couldn't handle arrays in YAML") do
      @cfg.load_yaml_file(File.join(File.dirname(__FILE__),'testyaml_arrays.yaml'))
    end
    log = Logger['mylogger']
    assert_instance_of(Array, log.outputters.first.array_param, 'Array not loaded properly from YAML')
    assert_equal('wilma@bar.com', log.outputters.first.array_param[2], '#{}-style parameter interpolation doesn\'t work properly in arrays')
  end
end

