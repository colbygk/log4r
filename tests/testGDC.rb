$: << File.join("..","lib")
require "test/unit"
require "log4r"
include Log4r

class TestGDC < Test::Unit::TestCase

  def test_gdc_default
    assert(GDC.get() == "testGDC.rb", "Expected 'testGDC.rb' got '#{GDC.get()}'" )
  end

  def test_gdc_set
    assert_nothing_raised() { GDC.set("testGDCset") }
    assert(GDC.get() == "testGDCset", "Expected 'testGDCset' got '#{GDC.get()}'" )
  end
  
  def test_gdc_threaded
    assert_nothing_raised() { GDC.set("testGDCset") }
    t = Thread.new("test GDC thread") do |name|
       assert_raise(RuntimeError) { GDC.set("somethingelse") }
    end
    t.join
    assert(GDC.get() == "testGDCset", "Expected 'testGDCset' got '#{GDC.get()}'" )
  end

end
