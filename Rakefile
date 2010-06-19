
# $Id$

# incorporated from Revolution Health version of log4r

require 'rubygems'
require 'rake/gempackagetask'
require 'rubygems/specification'
require 'date'
require 'fileutils'

GEM = "log4r"
GEM_VERSION = "1.1.9"
AUTHOR = "Colby Gutierrez-Kraybill"
EMAIL = "colby@astro.berkeley.edu"
HOMEPAGE = %q{http://log4r.rubyforge.org}
SUMMARY = "Log4r, logging framework for ruby"
DESCRIPTION = "See also: http://logging.apache.org/log4j"
DIRS = [ "doc/**/*", "examples/**/*", "lib/**/*", "tests/**/*" ]

spec = spec = Gem::Specification.new do |s|
  s.name = GEM
  s.rubyforge_project = s.name
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README", "LICENSE", 'TODO']
  s.summary = SUMMARY
  s.description = DESCRIPTION
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE

  # Uncomment this to add a dependency
  # s.add_dependency "foo"

  s.require_path = 'lib'
  s.files = %w(LICENSE LICENSE.LGPLv3 README INSTALL Rakefile TODO)
  s.files = s.files + DIRS.collect do |dir|
    Dir.glob( dir )
  end.flatten.delete_if { |f| f.include?("CVS") }
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "install the gem locally"
task :install => [:package] do
  sh %{sudo gem install pkg/#{GEM}-#{GEM_VERSION}}
end

desc "create a gemspec file"
task :make_spec do
  File.open("#{GEM}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end

# require 'test/unit'

# TODO: integrate unit tests
#task :test do
#  FileUtils.mkdir(File.join(File.dirname(__FILE__), %w[log])) if !File.exists?(File.join(File.dirname(__FILE__), %w[log]))
#  FileUtils.rm(Dir.glob(File.join(File.dirname(__FILE__), %w[log *])))
#  runner = Test::Unit::AutoRunner.new(true)
#  runner.to_run << 'test'
#  runner.pattern = [/_test.rb$/]
#  exit if !runner.run
#end

task :default => [:package] do
end

