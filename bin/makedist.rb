#!/usr/bin/ruby
#
# Run this file to prepare a distribution. Make sure the variables in
# devconfig.rb reflects your setup.
#
# Run from the bin directory and specify the version number as the first 
# and only argument

require 'ftools'
require 'devconfig'

$cvsname = 'log4r'        # name of log4r module, shouldn't be changed

# read version from input
if ARGV.size == 0
  puts "Usage: makedist.rb <version>"
  exit
end

$version = ARGV[0].split(".")
puts "makedist.rb: Building Log4r distribution #{$version.join '.'}"

##### Rest is standard package config

$dotver = $version.join '.'
$dashver = $version.join '-'

$package = $cvsname + '-' + $dotver
$packagedash = $cvsname + '-' + $dashver
$tarball = $package + '.tgz'
$zipfile = $packagedash + '.zip'
$docball = $cvsname + '-doc-' + $dotver + '.tgz'
$projdir = $prepdir + "/" + $package

##### Start program

# try the dirs out and die if they don't exist
unless File.directory? $prepdir
  raise TypeError, "#{prepdir} is not a dir."
end
unless File.directory? $releasedir
  raise TypeError, "#{releasedir} is not a dir."
end

# system commands
def run(cmd)
  unless system cmd + ($quiet ? "> /dev/null 2>&1" : "")
    raise RuntimeError, "unable to finish '#{cmd}'", caller
    exit
  end
end

puts "makedist.rb: checking out #{$cvsname}"
Dir.chdir $prepdir
# remove any previous instance of auto build
run "rm -rf #{$package}"

# check out the latest if testing, otherwise check out the cvstag version
system "cvs #{$cvsroot} co -d #{$package} #{$cvsname}"

Dir.chdir $package + "/bin"

# Now run each of the other files in bin to build documents and prune
# the cvs of junk for release
puts "makedist.rb: running makehtml.rb"
run "ruby makehtml.rb #{$dotver} #{$projdir}/doc"
puts "makedist.rb: runing prune.rb"
run "ruby prune.rb #{$projdir}"
puts "makedist.rb: running makerdoc.rb"
run "ruby makerdoc.rb #{$dotver} #{$projdir}/lib #{$projdir}/doc"
puts "makedist.rb: removing #{$projdir}/bin"
run "rm -rf #{$projdir}/bin"

### Release is ready, so zip it up

Dir.chdir $prepdir

puts "makedist.rb: making tarball"
run "tar -czf #{$tarball} #{$package}"
puts "makedist.rb: making zipfile"
run "zip -r #{$zipfile} #{$package}"
puts "makedist.rb: making documentation tarball"
run "tar -czvf #{$docball} #{$package}/doc"

puts "makedist.rb: moving results to #{$releasedir}"
File.mv $tarball, $releasedir
File.mv $zipfile, $releasedir
File.mv $docball, $releasedir

# make gemfile last
Dir.chdir $package
puts "makedist.rb: building gemfile in #{$releasedir}"
run "ruby log4r.gemspec"
File.mv $package + ".gem", $releasedir
