require 'rubygems'

spec = Gem::Specification.new do |s|

  s.name = 'log4r'
  s.version = "1.0.6"
  s.platform = Gem::Platform::RUBY
  s.summary = "Log4r is a comprehensive and flexible logging library for Ruby.  Following the design pattern of Log4j"
  s.has_rdoc = true

  s.files = [ "doc/**/*", "examples/**/*", "src/**/*", "tests/**/*" ].collect do |dir|
    Dir.glob( dir )
  end.flatten.delete_if { |f| f.include?("CVS") }

#s.files.concat( Dir.glob( "#{dir}/**/*" ).delete_if { |p| p.include?("CVS") } )
#end
#s.files.each { |f| puts f }

  s.require_path = 'src'
  s.author = "Colby Gutierrez-Kraybill"
  s.email = "colby(at)astro.berkeley.edu"
  s.homepage = "http://rubyforge.org/projects/log4r"
  s.rubyforge_project = "log4r"

  s.description = "Log4r is a comprehensive and flexible logging library written in Ruby for use in Ruby programs. It features a hierarchical logging system of any number of levels, custom level names, logger inheritance, multiple output destinations per log event, execution tracing, custom formatting, thread saftey, XML and YAML configuration, and more.  The design pattern for this project follows that of the Apache Log4j project."
end

if $0 == __FILE__
  Gem::Builder.new( spec ).build
end
