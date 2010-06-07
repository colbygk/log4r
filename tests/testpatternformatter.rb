$: << File.join("..","lib")
require "test/unit"
require "log4r"
include Log4r


class TestPatternFormatter < Test::Unit::TestCase
  def test_pattern
    l = Logger.new 'test::this::that'
    l.trace = true
    o = StdoutOutputter.new 'test' 
    l.add o
    assert_nothing_raised { 
    f = PatternFormatter.new :pattern=> "'%t' T-'%T' %d %6l [%C]%c %% %-40.30M"
                             #:date_pattern=> "%Y"
                             #:date_method => :usec
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

  def test_ndc
    l = Logger.new 'test::this::that::other'
    l.trace = true
    o = StdoutOutputter.new 'testy' 
    l.add o
    f = PatternFormatter.new :pattern=> "%d %6l [%C]%c {%x} %% %-40.30M"
                             #:date_pattern=> "%Y"
                             #:date_method => :usec
    Outputter['testy'].formatter = f

    l.info "no NDC"
    NDC.push("start")
    l.info "start NDC"
    NDC.push("finish")
    l.info "start finish NDC"
    NDC.pop()
    l.info "start NDC"
    NDC.remove()
    l.info "no NDC"
  end

  def test_gdc
    l = Logger.new 'test::this::that::other'
    l.trace = true
    o = StdoutOutputter.new 'testy' 
    l.add o
    f = PatternFormatter.new :pattern=> "%d %6l [%C]%c {%g} %% %-40.30M"
                             #:date_pattern=> "%Y"
                             #:date_method => :usec
    Outputter['testy'].formatter = f

    l.info "GDC default"
    GDC.set("non-default")
    l.info "GDC non-default"
  end

  def test_mdc
    l = Logger.new 'test::this::that::other'
    l.trace = true
    o = StdoutOutputter.new 'testy' 
    l.add o
    f = PatternFormatter.new :pattern=> "%d %6l [%C]%c {%X{user}} %% %-40.30M"
                             #:date_pattern=> "%Y"
                             #:date_method => :usec
    Outputter['testy'].formatter = f

    l.info "no user"
    MDC.put("user","colbygk")
    l.info "user colbygk"
  end
end
