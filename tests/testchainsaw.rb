require 'test_helper'

include Log4r

log4r = Logger.new 'log4r'
log4r.trace = true
log4r.outputters = StdoutOutputter.new 'log4r'
log4r.level = ALL

formatter = Log4jXmlFormatter.new
outputter = UDPOutputter.new 'udp', :hostname => "localhost", :port => 8071
outputter.formatter = formatter

mylog = Logger.new 'mylog'
mylog.trace = true
mylog.outputters = [outputter]

# Log4r::Formatter throws when formatting
# an excpetion with a nil backtrace (line 73).
def get_exception(msg)
  begin
    raise msg
  rescue Exception => e
    e
  end
end

NDC.push "saw test"

MDC.put "clientip", %q{10.33.33.33}

def do_log(log)
    log.debug "This is a message with level DEBUG"
    log.info "This is a message with level INFO"
    log.warn "This is a message with level WARN"
    log.error "This is a message with level ERROR"
    log.fatal "This is a message with level FATAL"

    log.fatal get_exception( "This is an exception" )
end

do_log(mylog)
