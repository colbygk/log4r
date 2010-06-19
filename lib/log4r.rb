# :include: log4r/rdoc/log4r
#
# == Other Info
#
# Author::      Leon Torres
# Version::     $Id$

require "log4r/outputter/fileoutputter"
require "log4r/outputter/consoleoutputters"
require "log4r/outputter/staticoutputter"
require "log4r/outputter/rollingfileoutputter"
require "log4r/formatter/patternformatter"
require "log4r/loggerfactory"
require "log4r/GDC"
require "log4r/NDC"
require "log4r/MDC"

module Log4r
  Log4rVersion = [1, 1, 9].join '.'
end
