
# $Id$

# incorporated from Revolution Health version of log4r

require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'bundler'

Bundler::GemHelper.install_tasks

task :default => :build

desc "Run basic tests"
Rake::TestTask.new :test do |t|
  t.pattern = 'tests/test*.rb'
#  t.verbose = true
#  t.warning = true
end
