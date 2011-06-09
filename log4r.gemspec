# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'rake'
require 'log4r/version'

Gem::Specification.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "log4r"
  gem.version = Log4r::VERSION
  gem.summary = %Q{Log4r, logging framework for ruby}
  gem.description = %Q{See also: http://logging.apache.org/log4j}
  gem.email = "colby@astro.berkeley.edu"
  gem.homepage = "http://log4r.rubyforge.org"
  gem.authors = ['Colby Gutierrez-Kraybill']
  gem.bindir = 'bin'
  gem.test_files = Dir.glob("tests/**/*")
  gem.files = FileList[ "doc/**/*", "examples/**/*", "lib/**/*" ]

  gem.add_dependency "builder", [">= 2.0.0"]
  gem.add_development_dependency "bundler", [">= 1.0.0"]
  gem.add_development_dependency 'rake', ["~> 0.8.7"]
end
