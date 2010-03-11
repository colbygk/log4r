$: << File.join("..", "src")

require 'log4r'
require 'log4r/staticlogger'
require 'log4r/formatter/log4jxmlformatter'
require 'log4r/outputter/udpoutputter'
require 'log4r/outputter/consoleoutputters'

include Log4r

log4r = Logger.new 'log4r'
log4r.trace = true
log4r.outputters = StdoutOutputter.new 'log4r'
log4r.level = ALL

formatter = Log4jXmlFormatter.new
outputter = UDPOutputter.new 'udp', "localhost", 8071
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

NDC.push 1
NDC.push "string"
NDC.push ["an", "array"]

#MDC.put "test", "windows"

def do_log(log)
    log.debug "This is a message with level DEBUG"
    log.info "This is a message with level INFO"
    log.warn "This is a message with level WARN"
    log.error "This is a message with level ERROR"
    log.fatal "This is a message with level FATAL"

    log.fatal get_exception( "This is an exception" )
end

do_log(mylog)
