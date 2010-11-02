# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{log4r}
  s.version = "1.1.10"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Colby Gutierrez-Kraybill"]
  s.date = %q{2010-11-02}
  s.description = %q{See also: http://logging.apache.org/log4j}
  s.email = %q{colby@astro.berkeley.edu}
  s.extra_rdoc_files = ["README", "LICENSE", "TODO"]
  s.files = ["LICENSE", "LICENSE.LGPLv3", "README", "INSTALL", "Rakefile", "TODO", "doc/log4r.css", "doc/templates", "doc/templates/main.html", "doc/dev", "doc/dev/README.developers", "doc/dev/checklist", "doc/dev/things-to-do", "doc/rdoc-log4r.css", "doc/content", "doc/content/contribute.html", "doc/content/contact.html", "doc/content/license.html", "doc/content/index.html", "doc/content/manual.html", "doc/images", "doc/images/log4r-logo.png", "doc/images/logo2.png", "examples/moderate.xml", "examples/yaml.rb", "examples/moderateconfig.rb", "examples/rrsetup.rb", "examples/customlevels.rb", "examples/ancestors.rb", "examples/rdoc-gen", "examples/rrconfig.xml", "examples/filelog.rb", "examples/myformatter.rb", "examples/fileroll.rb", "examples/outofthebox.rb", "examples/xmlconfig.rb", "examples/README", "examples/chainsaw_settings.xml", "examples/logserver.rb", "examples/gmail.yaml", "examples/syslogcustom.rb", "examples/simpleconfig.rb", "examples/log4r_yaml.yaml", "examples/logclient.rb", "examples/gmail.rb", "lib/log4r", "lib/log4r/base.rb", "lib/log4r/MDC.rb", "lib/log4r/staticlogger.rb", "lib/log4r/GDC.rb", "lib/log4r/rdoc", "lib/log4r/rdoc/GDC", "lib/log4r/rdoc/log4r", "lib/log4r/rdoc/yamlconfigurator", "lib/log4r/rdoc/logserver", "lib/log4r/rdoc/outputter", "lib/log4r/rdoc/syslogoutputter", "lib/log4r/rdoc/patternformatter", "lib/log4r/rdoc/configurator", "lib/log4r/rdoc/emailoutputter", "lib/log4r/rdoc/logger", "lib/log4r/rdoc/MDC", "lib/log4r/rdoc/NDC", "lib/log4r/rdoc/win32eventoutputter", "lib/log4r/rdoc/scribeoutputter", "lib/log4r/rdoc/formatter", "lib/log4r/repository.rb", "lib/log4r/NDC.rb", "lib/log4r/logger.rb", "lib/log4r/config.rb", "lib/log4r/lib", "lib/log4r/lib/xmlloader.rb", "lib/log4r/lib/drbloader.rb", "lib/log4r/logevent.rb", "lib/log4r/configurator.rb", "lib/log4r/outputter", "lib/log4r/outputter/rollingfileoutputter.rb", "lib/log4r/outputter/udpoutputter.rb", "lib/log4r/outputter/emailoutputter.rb", "lib/log4r/outputter/syslogoutputter.rb", "lib/log4r/outputter/staticoutputter.rb", "lib/log4r/outputter/outputter.rb", "lib/log4r/outputter/remoteoutputter.rb", "lib/log4r/outputter/iooutputter.rb", "lib/log4r/outputter/fileoutputter.rb", "lib/log4r/outputter/outputterfactory.rb", "lib/log4r/outputter/datefileoutputter.rb", "lib/log4r/outputter/consoleoutputters.rb", "lib/log4r/outputter/scribeoutputter.rb", "lib/log4r/logserver.rb", "lib/log4r/yamlconfigurator.rb", "lib/log4r/loggerfactory.rb", "lib/log4r/formatter", "lib/log4r/formatter/log4jxmlformatter.rb", "lib/log4r/formatter/patternformatter.rb", "lib/log4r/formatter/formatter.rb", "lib/log4r.rb", "tests/testall.rb", "tests/testcustom.rb", "tests/testGDC.rb", "tests/testMDC.rb", "tests/testxmlconf.rb", "tests/testformatter.rb", "tests/testoutputter.rb", "tests/testpatternformatter.rb", "tests/README", "tests/testNDC.rb", "tests/testthreads.rb", "tests/testconf.xml", "tests/testchainsaw.rb", "tests/testbase.rb", "tests/testlogger.rb"]
  s.homepage = %q{http://log4r.rubyforge.org}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{log4r}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Log4r, logging framework for ruby}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<scribe>, [">= 0"])
    else
      s.add_dependency(%q<scribe>, [">= 0"])
    end
  else
    s.add_dependency(%q<scribe>, [">= 0"])
  end
end
