require 'rbconfig'
require 'find'
require 'ftools'

include Config

# this was adapted from rdoc's install.rb (I hope Dave doesn't mind :)

$sitedir = CONFIG["sitelibdir"]
unless $sitedir
  version = CONFIG["MAJOR"] + "." + CONFIG["MINOR"]
  $libdir = File.join(CONFIG["libdir"], "ruby", version)
  $sitedir = $:.find {|x| x =~ /site_ruby/ }
  if !$sitedir
    $sitedir = File.join($libdir, "site_ruby")
  elsif $sitedir !~ Regexp.quote(version)
    $sitedir = File.join($sitedir, version)
  end
end

makedirs = %w{ log4r/outputter log4r/formatter log4r/lib}
makedirs.each {|f| File::makedirs(File.join($sitedir, *f.split(/\//)))}

# deprecated files that should be removed
deprecated = %w{
 log4r/formatter.rb
 log4r/outputter.rb
 log4r/outputters.rb
 log4r/outputterfactory.rb
 log4r/patternformatter.rb
}

# files to install in library path
files = %w-
 log4r.rb
 log4r/base.rb
 log4r/config.rb
 log4r/configurator.rb
 log4r/yamlconfigurator.rb
 log4r/logevent.rb
 log4r/logger.rb
 log4r/loggerfactory.rb
 log4r/logserver.rb
 log4r/repository.rb
 log4r/staticlogger.rb
 log4r/outputter/consoleoutputters.rb
 log4r/outputter/emailoutputter.rb
 log4r/outputter/fileoutputter.rb
 log4r/outputter/rollingfileoutputter.rb
 log4r/outputter/iooutputter.rb
 log4r/outputter/outputter.rb
 log4r/outputter/outputterfactory.rb
 log4r/outputter/remoteoutputter.rb
 log4r/outputter/staticoutputter.rb
 log4r/outputter/syslogoutputter.rb
 log4r/formatter/formatter.rb
 log4r/formatter/patternformatter.rb
 log4r/lib/xmlloader.rb
 log4r/lib/drbloader.rb
-

# the acual gruntwork
Dir.chdir("src")
File::safe_unlink *deprecated.collect{|f| File.join($sitedir, f.split(/\//))}
files.each {|f| 
  File::install(f, File.join($sitedir, *f.split(/\//)), 0644, true)
}
