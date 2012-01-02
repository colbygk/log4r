require 'test_helper'

class TestMDC < TestCase
  include Log4r

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

  def test_MDCoutput
    Log4r::MDC.put(:user, "symbol")
    Log4r::MDC.put("string", "string")
    Log4r::MDC.put(5, "number")
    l = Logger.new 'test'
    o = StdoutOutputter.new 'test'
    l.add o
    assert_nothing_raised {
      f = PatternFormatter.new :pattern=> "%l user: %X{:user} %X{strng} %X{5}"
      Outputter['test'].formatter = f
      l.debug "And this?"
      l.info "How's this?"
      l.error "and a really freaking huge line which we hope will be trimmed?"
      e = ArgumentError.new("something barfed")
      e.set_backtrace Array.new(5, "trace junk at thisfile.rb 154")
      l.fatal e
      l.info [1, 3, 5]
    }

  end
end
