require 'test_helper'

One=<<-EOX
<log4r_config><pre_config><custom_levels> Foo </custom_levels>
</pre_config></log4r_config>
EOX
Two=<<-EOX
<log4r_config><pre_config><global level="DEBUG"/></pre_config></log4r_config>
EOX
Three=<<-EOX
<log4r_config><pre_config><custom_levels>Foo</custom_levels>
<global level="Foo"/></pre_config>
</log4r_config>
EOX

# must be run independently
class TestXmlConf < TestCase
  include Log4r

  def test_load1
    Configurator.load_xml_string(One)
    assert_nothing_raised{ 
      assert(Foo == 1) 
      assert(Logger.global.level == ALL)
    }
  end
  def test_load2
    Configurator.load_xml_string(Two)
    assert_nothing_raised{ 
      assert(Logger.global.level == DEBUG)
    }
  end
  def test_load3
    Configurator.load_xml_string(Three)
    assert_nothing_raised{ 
      assert(Foo == 1) 
      assert(Logger.global.level == Foo)
    }
  end
  def test_load4
    assert_nothing_raised {
      Configurator['logpath'] = '.'
      Configurator.load_xml_file "xml/testconf.xml"
      a = Logger['first::second']
      a.bing "what the heck"
    }
  end
end
