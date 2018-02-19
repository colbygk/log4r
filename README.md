Log4r - A flexible logging library for Ruby


|||
|:-----------|-|
|This release|1.1.11|
|Release date|04/Jan/2014|
|License|BSD|
|Maintainer|Colby Gutierrez-Kraybill|

|Contributor| |
|:-----------|:-|
|Leon Torres|Original Maintainer|
|Martain Stannard|RollingFileOutputter|
|Steve Lumos|SyslogOutputter|
|Mark Lewandowski|ScribeOutputter|
|Andreas Hund|YamlConfigurator|
|Jamis Buck|log4r.gemspec|
|Charles Strahan|log4jxml/chainsaw integration|
|Nitay Joffe|STARTTLS|
|David Siegal|Smart updates to RollingFileOutputter|

Summary
-------

Log4r is a comprehensive and flexible logging library written in Ruby for use 
in Ruby programs. It features a hierarchical logging system of any number of 
levels, custom level names, logger inheritance, multiple output destinations 
per log event, execution tracing, custom formatting, thread safteyness, XML 
and YAML configuration, and more.


Requirements
------------

1. (required) Ruby >= 1.7.0 (use log4r 1.0.2 for Ruby 1.6)
2. (optional) RubyGems for installing Log4r as a gem
3. (optional) Ruby syslog library for SyslogOutputter
4. (optional) XML configuration requires REXML
5. (optional) log4j chainsaw integration requires 'builder' >= 2.0
6. (optional) STARTTLS email login, requires 'smtp_tls" if Ruby <= 1.8.6


More Info
---------

* Installation instructions are in the file INSTALL
* Comprehensive examples are provided in examples/ and can be run right away
* Log4r homepage: doc/index.html
* Manual: doc/manual.html
* RDoc API reference: doc/rdoc/index.html 
* The changelog
* Feel free to bug the maintainer with any questions (listed at top of file)

Usability
---------

Log4r works really well, so please take advantage of it right away! :)
All versions since 0.9.2 have been stable and backward-compatible. The
code is stable enough that updates are infrequent and usually only for
adding features or keeping the code up to date with Ruby.


Platform Issues
---------------

Log4r is known to work on Linux and WindowsXP. It's safe to assume that Log4r 
will work on any Ruby-supported platform.


When Trouble Strikes
--------------------

Log4r comes with an internal logger. To see its output, create a logger
named 'log4r' before any others and give it a suitable outputter,

  trouble = Logger.new['log4r']
  trouble.add Outputter.stdout

Try running the unit tests provided (run the file tests/runtest.rb). Let
the maintainer know what's up and feel free to explore and fix the 
code yourself. It's well documented and written in Ruby. :)


