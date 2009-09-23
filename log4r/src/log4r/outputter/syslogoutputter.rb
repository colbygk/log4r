# :include: ../rdoc/syslogoutputter
#
# Version:: $Id$
# Author:: Steve Lumos
# Author:: Leon Torres

require 'log4r/formatter/formatter'
require 'log4r/outputter/outputter'
require 'log4r/configurator'
require 'syslog'

module Log4r

  # syslog needs to set the custom levels
  #if LNAMES.size > 1
  #  raise LoadError, "Must let syslogger.rb define custom levels"
  #end
  # tune log4r to syslog priorities
  #Configurator.custom_levels("DEBUG", "INFO", "NOTICE", "WARNING", "ERR", "CRIT", "ALERT", "EMERG")

  SYSLOGNAMES = Hash.new

  class SyslogOutputter < Outputter
    include Syslog::Constants

    # maps default log4r levels to syslog priorities (logevents never see ALL and OFF)
    SYSLOG_LEVELS_MAP = {
      "DEBUG"  => LOG_DEBUG, 
      "INFO"   => LOG_INFO, 
      "NOTICE" => LOG_NOTICE,  # by default NOTICE is not in log4r
      "WARN"   => LOG_WARNING, 
      "ERROR"  => LOG_ERR, 
      "FATAL"  => LOG_CRIT,
      "ALERT"  => LOG_ALERT,   # by default ALERT is not in log4r
      "EMERG"  => LOG_EMERG,   # by default EMERG is not in log4r
    }

    SYSLOG_LOG4R_MAP = {
      "DEBUG"  => "DEBUG", 
      "INFO"   => "INFO", 
      "WARN"   => "WARN", 
      "ERROR"  => "ERROR", 
      "FATAL"  => "FATAL"
      # "NOTICE" => "INFO",      # by default NOTICE is not in log4r
      # "ALERT"  => "FATAL",     # by default ALERT is not in log4r
      # "EMERG"  => "FATAL"      # by default EMERG is not in log4r
    }

    @levels_map = SYSLOG_LOG4R_MAP

    # There are 3 hash arguments
    #
    # [<tt>:ident</tt>]     syslog ident, defaults to _name
    # [<tt>:logopt</tt>]    syslog logopt, defaults to LOG_PID | LOG_CONS
    # [<tt>:facility</tt>]  syslog facility, defaults to LOG_USER
    def initialize(_name, hash={})
      super(_name, hash)
      ident = (hash[:ident] or hash['ident'] or _name)
      logopt = (hash[:logopt] or hash['logopt'] or LOG_PID | LOG_CONS).to_i
      facility = (hash[:facility] or hash['facility'] or LOG_USER).to_i
      map_levels_by_name_to_syslog()
      @syslog = Syslog.open(ident, logopt, facility)
    end

    def closed?
      return !@syslog.opened?
    end

    def close
      @syslog.close unless @syslog.nil?
      @level = OFF
      OutputterFactory.create_methods(self)
      Logger.log_internal {"Outputter '#{@name}' closed Syslog and set to OFF"}
    end

    # A single hash argument that maps custom names to syslog names
    # 
    # [<tt>levels_map</tt>]	A map that will create a linkage between levels
    # 				in a hash and underlying syslog levels.
    # 				By default, these are direct mapping of the log4r
    # 				levels (e.g. "DEBUG" => "DEBUG")
    # 				If you have defined your own custom levels, you
    # 				should provide this underlying mapping, otherwise
    # 				all messages will be mapped to the underlying syslog
    # 				level of INFO by default.
    def map_levels_by_name_to_syslog( lmap = SYSLOG_LOG4R_MAP )
      @levels_map = lmap
    end

    def get_levels_map()
      return @levels_map
    end

    private

    def canonical_log(logevent)
      pri = SYSLOG_LEVELS_MAP[@levels_map[LNAMES[logevent.level]]] rescue pri = LOG_INFO
      o = format(logevent)
      if o.kind_of? Exception then
	msg = "#{o.class} at (#{o.backtrace[0]}): #{o.message}"
      elsif o.respond_to? :to_str then
	msg = o.to_str
      else
	msg = o.inspect
      end

      @syslog.log(pri, '%s', msg)
    end
  end
end
