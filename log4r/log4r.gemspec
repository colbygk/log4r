require 'rubygems'

dist_dirs = [ "doc", "examples", "src", "tests" ]

spec = Gem::Specification.new do |s|

  s.name = 'log4r'
  s.version = "1.0.5"
  s.platform = Gem::Platform::RUBY
  s.summary = "Log4r is a comprehensive and flexible logging library for Ruby."
  s.has_rdoc = true

  s.files = []
  dist_dirs.each do |dir|
    s.files.concat Dir.glob( "#{dir}/**/*" ).delete_if { |item| item.include?( "CVS" ) }
  end

  s.require_path = 'src'
  s.autorequire = 'log4r'
  s.author = "Leon Torres"
  s.email = "leon(at)ugcs.caltech.edu"
  s.homepage = "http://log4r.sourceforge.net"

  s.description = "Log4r is a comprehensive and flexible logging library written in Ruby for use in Ruby programs. It features a hierarchical logging system of any number of levels, custom level names, logger inheritance, multiple output destinations per log event, execution tracing, custom formatting, thread safteyness, XML and YAML configuration, and more."
end

if $0 == __FILE__
  Gem::Builder.new( spec ).build
end
