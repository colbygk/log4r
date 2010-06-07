$: << File.join("..","lib")
require "test/unit"
require "log4r"
include Log4r

class TestNDC < Test::Unit::TestCase

  def test_ndc_remove_push
    NDC.remove()
    NDC.push("ndc")
    assert(Log4r::NDC.get() == "ndc", "Expected 'ndc' got '#{NDC.get()}'" )
    NDC.push("ndc")
    assert(Log4r::NDC.get() == "ndc ndc", "Expected 'ndc ndc' got '#{NDC.get()}'" )
  end

  def test_ndc_remove_push_clone_and_inherit
    NDC.remove()
    NDC.push("ndc")
    NDC.push("ndc")
    a = NDC.clone_stack()
    NDC.remove()
    assert(NDC.get() == "", "Expected '' got '#{NDC.get()}'" )
    NDC.inherit(a)
    assert(NDC.get() == "ndc ndc", "Expected 'ndc ndc' got '#{NDC.get()}'" )
  end

end
