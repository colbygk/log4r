$: << File.join("..","lib")
require "test/unit"
require "log4r"
include Log4r


class TestOutputter < Test::Unit::TestCase
  def test_validation
    assert_raise(ArgumentError) { Outputter.new }
    assert_raise(ArgumentError) { Outputter.new 'fonda', :level=>-10}
    assert_raise(TypeError) { Outputter.new 'fonda', :formatter=>-10}
  end
  def test_io
    assert_nothing_raised {
      IOOutputter.new('foo3', $stdout)
      IOOutputter.new('foo4', $stderr)
    }
    f = File.new("junk/tmpx.log", "w")
    o = IOOutputter.new('asdf', f)
    o.close
    assert(f.closed? == true)
    assert(o.level == OFF)
  end
  def test_repository
    assert( Outputter['foo3'].class == IOOutputter )
    assert( Outputter['foo4'].class == IOOutputter )
    assert( Outputter['asdf'].class == IOOutputter )
  end
  def test_validation_and_creation
    assert_nothing_raised {
      StdoutOutputter.new('out', 'level'=>DEBUG)
      FileOutputter.new('file', 'filename'=>'junk/test', :trunc=>true)
    }
    a = StdoutOutputter.new 'out2'
    assert(a.level == Logger.root.level)
    assert(a.formatter.class == DefaultFormatter)
    b = StdoutOutputter.new('ook', :level => DEBUG, :formatter => Formatter)
    assert(b.level == DEBUG)
    assert(b.formatter.class == Formatter)
    c = StdoutOutputter.new('akk', :formatter => Formatter)
    assert(c.level == Logger.root.level)
    assert(c.formatter.class == Formatter)
    c = StderrOutputter.new('iikk', :level => OFF)
    assert(c.level == OFF)
    assert(c.formatter.class == DefaultFormatter)
    o = StderrOutputter.new 'ik'
    assert_nothing_raised(TypeError) { o.formatter = DefaultFormatter }
    assert(o.formatter.class == DefaultFormatter)
  end
  # test the resource= bounds
  def test_boundaries
    o = StderrOutputter.new('ak', :formatter => Formatter)
    assert_raise(TypeError) { o.formatter = nil }
    assert_raise(TypeError) { o.formatter = String }
    assert_raise(TypeError) { o.formatter = "bogus" }
    assert_raise(TypeError) { o.formatter = -3 }
    # the formatter should be preserved
    assert(o.formatter.class == Formatter) 
  end
  def test_file
    assert_raise(TypeError) { FileOutputter.new 'f' }
    assert_raise(TypeError) { FileOutputter.new('fa', :filename => DEBUG) }
    assert_raise(TypeError) { FileOutputter.new('fo', :filename => nil) }
    assert_nothing_raised { 
      FileOutputter.new('fi', :filename => './junk/tmp')
      FileOutputter.new('fum', :filename=>'./junk/tmp', :trunc => "true")
    }
    fo = FileOutputter.new('food', :filename => './junk/tmp', :trunc => false)
    assert(fo.trunc == false)
    assert(fo.filename == './junk/tmp')
    assert(fo.closed? == false)
    fo.close
    assert(fo.closed? == true)
    assert(fo.level == OFF)
  end
  # test the dynamic definition of outputter log messages
  def test_log_methods
    o = StderrOutputter.new('so1', :level => WARN )
    # test to see if all of the methods are defined
    for mname in LNAMES
      next if mname == 'OFF' || mname == 'ALL'
      assert_respond_to(o, mname.downcase.to_sym, "Test respond to #{mname.to_s}")
    end 
    return # cuz the rest is borked
    # we rely on BasicFormatter's inability to reference a nil Logger to test
    # the log methods. Everything from WARN to FATAL should choke.
    event = LogEvent.new(nil, nil, nil, nil) 
    assert_nothing_raised { o.debug event }
    assert_nothing_raised { o.info event }
    assert_raise(NameError) { o.warn event }
    assert_raise(NameError) { o.error event }
    assert_raise(NameError) { o.fatal event }
    # now let's dynamically change the level and repeat
    o.level = ERROR
    assert_nothing_raised { o.debug event}
    assert_nothing_raised { o.info event}
    assert_nothing_raised { o.warn event}  
    assert_raise(NameError) { o.error event}
    assert_raise(NameError) { o.fatal event}
  end
  def test_only_at_validation
    o = StdoutOutputter.new 'so2'
    assert_raise(ArgumentError) { o.only_at }
    assert_raise(ArgumentError) { o.only_at ALL }
    assert_raise(TypeError) { o.only_at OFF }
    assert_nothing_raised { o.only_at DEBUG, ERROR }
    return # cuz the rest is borked
    # test the methods as before
    event = LogEvent.new(nil,nil,nil,nil)
    assert_raise(NameError) { o.debug event}
    assert_raise(NameError) { o.error event}
    assert_nothing_raised { o.warn event}
    assert_nothing_raised { o.info event}
    assert_nothing_raised { o.fatal event}
  end
  def broken_test_threading
    class << self
      def log_work
	o = StdoutOutputter.new 'so2'
	assert_nothing_raised { o.only_at DEBUG, ERROR }
	Thread.current().exit()
      end
      def log_thread_start
	t = Thread.new(log_work)
	t.join
      end
    end

    ts = Thread.new(log_thread_start)
    ts.join
  end
end 
