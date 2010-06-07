$: << File.join("..","lib")

# This file demonstrates how inheritence works in log4r
#
require 'rubygems'
require 'log4r'
include Log4r

Logger.global.level = ALL
formatter = PatternFormatter.new(:pattern => "%l - %m - %c")
StdoutOutputter.new('console', :formatter => formatter)


# By default, the root logger is the top ancestor to the
# immediate descendants
# However, any descendants below the top ancestors will
# have the ancestor as their RootLogger, which dictates
# (among other things) the lowest level of log messages
Logger.new('grandparent', FATAL).add('console')
Logger.new('grandparent::parent', DEBUG)
Logger.new('grandparent::parent::child', DEBUG)


def do_logging(log)
  puts "--"
  log.debug "This is debug"
  log.info "This is info"
  log.warn "This is warn"
  log.error "This is error"
  log.fatal "This is fatal"
end

# This logger is configured to log at FATAL, and it does
do_logging Logger['grandparent']

# This logger is configured to log at DEBUG level, but it logs
# at FATAL because grandparent is now the RootLogger for parent
do_logging Logger['grandparent::parent']

# 'child' logger is configured to log at DEBUG level, but it logs
# at FATAL because of grandparent
do_logging Logger['grandparent::parent::child']


Logger['grandparent'].level = DEBUG
# Now that the grandparent's level is set to DEBUG, the child
# will log at that level
do_logging Logger['grandparent::parent::child']

Logger['grandparent'].level = OFF
puts "off?"
do_logging Logger['grandparent::parent::child']

