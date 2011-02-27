$: << File.join('..','lib') # path if log4r is not installed
require "test/unit"
require 'log4r'
require 'log4r/yamlconfigurator'
include Log4r

class TestYaml < Test::Unit::TestCase

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
#    log = Logger['mylogger']
#    assert_equal('wilma@bar.com', log.outputters['stderr']['recipients'][2])
  end
end



