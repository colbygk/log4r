# Cleans up a CVS co of log4r for distribution

require 'ftools'
require 'devconfig'

if ARGV.size != 1
  puts "Usage: prune.rb <projectdir>"
  exit
end

$projhome = (ARGV[0] or ".")
$echo = nil     # change to "echo" if need to debug, otherwise nil

# recursively delete any such directory or file with rm -rf
recursedel = %w{ CVS }
# some dirs aren't checked out with -r, so create them
mkdirs = %w{ tests/logs examples/logs }

def run(cmd)
  unless system cmd
    raise RuntimeError, "unable to finish '#{cmd}'", caller
    exit
  end
end

Dir.chdir $projhome

for dir in recursedel 
  run "find . -name #{dir} -exec #{$echo} rm -rf {} \\; -prune"
end
for dir in $deletedirs
  run "#{$echo} rm -rf #{dir}"
end
for file in $deletefiles
  run "#{$echo} rm -f #{file}"
end
File.makedirs *mkdirs
