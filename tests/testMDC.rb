$: << File.join("..","src")
require "test/unit"
require "log4r"
include Log4r

class TestMDC < Test::Unit::TestCase

  def test_multithread_copy
    Log4r::MDC.put("user","colbygk")
    t = Thread.new("test first copy") do |name|
      assert(Log4r::MDC.get("user") == "colbygk",
	     "Did not get back expected value, '#{MDC.get("user")}'")
      Log4r::MDC.put("user","unique")
      assert(Log4r::MDC.get("user") == "unique",
	     "Did not get back expected value, '#{MDC.get("user")}'")
    end
    t.join
    assert(Log4r::MDC.get("user") == "colbygk",
	   "Did not get back expected value, '#{MDC.get("user")}'")
  end
end
