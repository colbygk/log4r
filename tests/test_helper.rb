$:.unshift(File.dirname(__FILE__))

require "test/unit"
require 'log4r'
require 'log4r/configurator'
require 'log4r/staticlogger'
require 'log4r/formatter/log4jxmlformatter'
require 'log4r/outputter/udpoutputter'
require 'log4r/outputter/consoleoutputters'
require 'log4r/yamlconfigurator'

include Test::Unit
