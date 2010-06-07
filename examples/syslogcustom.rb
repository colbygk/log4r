# Suppose we don't like having 5 levels named DEBUG, INFO, etc.
# Suppose we'd rather use 3 levels named Foo, Bar, and Baz.
# Suppose we'd like to use these with syslog
# Log4r allows you to rename the levels and their corresponding methods
# in a painless way and then map those to corrisponding syslog levels
# or have them all default to LOG_INFO
# This file provides an example

$: << '../lib'

require 'log4r'
require 'log4r/configurator'
require 'log4r/formatter/patternformatter'
require 'log4r/outputter/syslogoutputter'
require 'syslog'
include Log4r
include Syslog::Constants

# This is how we specify our levels
Configurator.custom_levels "Foo", "Bar", "Baz"

l = Logger.new('custom levels')
slp = PatternFormatter.new( :pattern => '{%p} {%h} {%d} {%l} {%C} {%m}', :date_method => 'usec' )
sl = SyslogOutputter.new( 'sysloggertest', 
			 { :logopt => LOG_CONS | LOG_PID | LOG_PERROR,
			   :facility => LOG_LOCAL7,
			   :formatter => slp } )
sl.map_levels_by_name_to_syslog( { "Foo" => "DEBUG", "Bar" => "INFO", "Baz" => "ALERT" } )
l.add sl

l.level = Foo
puts l.foo?
l.foo "This is foo"
puts l.bar?
l.bar "this is bar"
puts l.baz?
l.baz "this is baz"

puts "Now change to Baz"

l.level = Baz
puts l.foo?
l.foo {"This is foo"}
puts l.bar?
l.bar {"this is bar"}
puts l.baz?
l.baz {"this is baz"}

l4r = Logger.new('log4r')
l4r.add Log4r::Outputter.stderr

Log4r::SyslogOutputter.new 'test'
