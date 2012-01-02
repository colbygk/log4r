# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'log4r/version'

# Removed dependency on rake because of error when running `bundle install --deployment`
#   There was a LoadError while evaluating log4r.gemspec:
#     no such file to load -- rake from
#     vendor/bundle/ruby/1.8/bundler/gems/log4r/log4r.gemspec:3

Gem::Specification.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "log4r"
  gem.version = Log4r::VERSION
  gem.summary = %Q{Log4r, logging framework for ruby}
  gem.description = %Q{See also: http://logging.apache.org/log4j}
  gem.email = "colby@sri.com"
  gem.homepage = "http://log4r.rubyforge.org"
  gem.authors = ['Colby Gutierrez-Kraybill']
  gem.bindir = 'bin'
  gem.test_files = Dir.glob("tests/**/*")
  gem.files = Dir['doc/**/*'] + Dir['examples/**/*'] + Dir['lib/**/*']

  gem.add_dependency "builder", [">= 2.0.0"]
  gem.add_development_dependency "bundler", [">= 1.0.0"]
  gem.add_development_dependency 'rake', ["~> 0.8.7"]

  if gem.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    gem.specification_version = 3
    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q{scribe}, [">= 0"])
    else
      s.add_dependency(%q{scribe}, [">= 0"])
    end
  else
    s.add_dependency(%q{scribe}, [">= 0"])
  end
end
