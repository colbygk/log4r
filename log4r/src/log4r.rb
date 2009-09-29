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

module Log4r
  Log4rVersion = [1, 1, 3].join '.'
end
