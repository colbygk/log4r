require 'test_helper'

class TestFormatter < TestCase
  include Log4r

  def test_creation
    assert_nothing_raised { Formatter.new.format(3) }
    assert_nothing_raised { DefaultFormatter.new }
    assert_kind_of(Formatter, DefaultFormatter.new)
  end
  def test_simple_formatter
    sf = SimpleFormatter.new
    f = Logger.new('simple formatter')
    event = LogEvent.new(0, f, nil, "some data")
    assert_match(/simple formatter/, sf.format(event))
  end
  def test_basic_formatter
    b = BasicFormatter.new
    f = Logger.new('fake formatter')
    event = LogEvent.new(0, f, caller, "fake formatter")
    event2 = LogEvent.new(0, f, nil, "fake formatter")
    # this checks for tracing
    assert_match(/in/, b.format(event))
    assert_not_match(/in/, b.format(event2))
    e = ArgumentError.new("argerror")
    e.set_backtrace ['backtrace']
    event3 = LogEvent.new(0, f, nil, e)
    assert_match(/ArgumentError/, b.format(event3))
    assert_match(/Array/, b.format(LogEvent.new(0,f,nil,[1,2,3])))
  end
end
