# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{log4r}
  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Colby Gutierrez-Kraybill"]
  s.date = %q{2009-09-22}
  s.description = %q{See also: http://logging.apache.org/log4j}
  s.email = %q{colby@astro.berkeley.edu}
  s.extra_rdoc_files = ["README", "LICENSE", "TODO"]
  s.files = ["LICENSE", "LICENSE.LGPLv3", "README", "INSTALL", "Rakefile", "TODO", "src/CVS", "src/CVS/Entries", "src/CVS/Repository", "src/CVS/Root", "src/log4r", "src/log4r/base.rb", "src/log4r/config.rb", "src/log4r/configurator.rb", "src/log4r/CVS", "src/log4r/CVS/Entries", "src/log4r/CVS/Repository", "src/log4r/CVS/Root", "src/log4r/formatter", "src/log4r/formatter/CVS", "src/log4r/formatter/CVS/Entries", "src/log4r/formatter/CVS/Repository", "src/log4r/formatter/CVS/Root", "src/log4r/formatter/formatter.rb", "src/log4r/formatter/patternformatter.rb", "src/log4r/lib", "src/log4r/lib/CVS", "src/log4r/lib/CVS/Entries", "src/log4r/lib/CVS/Repository", "src/log4r/lib/CVS/Root", "src/log4r/lib/drbloader.rb", "src/log4r/lib/xmlloader.rb", "src/log4r/logevent.rb", "src/log4r/logger.rb", "src/log4r/loggerfactory.rb", "src/log4r/logserver.rb", "src/log4r/outputter", "src/log4r/outputter/consoleoutputters.rb", "src/log4r/outputter/CVS", "src/log4r/outputter/CVS/Entries", "src/log4r/outputter/CVS/Repository", "src/log4r/outputter/CVS/Root", "src/log4r/outputter/datefileoutputter.rb", "src/log4r/outputter/emailoutputter.rb", "src/log4r/outputter/fileoutputter.rb", "src/log4r/outputter/iooutputter.rb", "src/log4r/outputter/outputter.rb", "src/log4r/outputter/outputterfactory.rb", "src/log4r/outputter/remoteoutputter.rb", "src/log4r/outputter/rollingfileoutputter.rb", "src/log4r/outputter/staticoutputter.rb", "src/log4r/outputter/syslogoutputter.rb", "src/log4r/rdoc", "src/log4r/rdoc/configurator", "src/log4r/rdoc/CVS", "src/log4r/rdoc/CVS/Entries", "src/log4r/rdoc/CVS/Repository", "src/log4r/rdoc/CVS/Root", "src/log4r/rdoc/emailoutputter", "src/log4r/rdoc/formatter", "src/log4r/rdoc/log4r", "src/log4r/rdoc/logger", "src/log4r/rdoc/logserver", "src/log4r/rdoc/outputter", "src/log4r/rdoc/patternformatter", "src/log4r/rdoc/syslogoutputter", "src/log4r/rdoc/yamlconfigurator", "src/log4r/repository.rb", "src/log4r/staticlogger.rb", "src/log4r/yamlconfigurator.rb", "src/log4r.rb", "examples/customlevels.rb", "examples/CVS", "examples/CVS/Entries", "examples/CVS/Repository", "examples/CVS/Root", "examples/fileroll.rb", "examples/log4r_yaml.yaml", "examples/logclient.rb", "examples/logserver.rb", "examples/moderate.xml", "examples/moderateconfig.rb", "examples/myformatter.rb", "examples/outofthebox.rb", "examples/README", "examples/rrconfig.xml", "examples/rrsetup.rb", "examples/simpleconfig.rb", "examples/xmlconfig.rb", "examples/yaml.rb", "tests/CVS", "tests/CVS/Entries", "tests/CVS/Repository", "tests/CVS/Root", "tests/README", "tests/testall.rb", "tests/testbase.rb", "tests/testconf.xml", "tests/testcustom.rb", "tests/testformatter.rb", "tests/testlogger.rb", "tests/testoutputter.rb", "tests/testpatternformatter.rb", "tests/testxmlconf.rb", "doc/content", "doc/content/contact.html", "doc/content/contribute.html", "doc/content/CVS", "doc/content/CVS/Entries", "doc/content/CVS/Repository", "doc/content/CVS/Root", "doc/content/index.html", "doc/content/license.html", "doc/content/manual.html", "doc/CVS", "doc/CVS/Entries", "doc/CVS/Repository", "doc/CVS/Root", "doc/dev", "doc/dev/checklist", "doc/dev/CVS", "doc/dev/CVS/Entries", "doc/dev/CVS/Repository", "doc/dev/CVS/Root", "doc/dev/README.developers", "doc/dev/things-to-do", "doc/images", "doc/images/CVS", "doc/images/CVS/Entries", "doc/images/CVS/Repository", "doc/images/CVS/Root", "doc/images/log4r-logo.png", "doc/images/logo2.png", "doc/log4r.css", "doc/templates", "doc/templates/CVS", "doc/templates/CVS/Entries", "doc/templates/CVS/Repository", "doc/templates/CVS/Root", "doc/templates/main.html", "bin/CVS", "bin/CVS/Entries", "bin/CVS/Repository", "bin/CVS/Root", "bin/devconfig.rb", "bin/makedist.rb", "bin/makehtml.rb", "bin/makerdoc.rb", "bin/prune.rb", "bin/README"]
  s.homepage = %q{http://log4r.rubyforge.org}
  s.require_paths = ["src"]
  s.rubyforge_project = %q{log4r}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Log4r, logging framework for ruby}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
