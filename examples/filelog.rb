# Here's how to start using log4r right away
$: << File.join('..','lib')                   # path if log4r not installed
require "log4r"

Log = Log4r::Logger.new("filelog")        # create a logger
# add FileOutputter
Log.add Log4r::FileOutputter.new( "filelog", {:filename=>"file.log"} )

# See book keeping logger events
iLog = Log4r::Logger.new("log4r")
iLog.add Log4r::Outputter.stderr

# do some logging
def do_logging
 Log.debug "debugging"
 Log.info "a piece of info"
 Log.warn "Danger, Will Robinson, danger!"
 Log.error "I dropped my Wookie! :("
 Log.fatal "kaboom!"
end
do_logging

# now let's filter anything below WARN level (DEBUG and INFO)
Log.level = Log4r::WARN
do_logging
