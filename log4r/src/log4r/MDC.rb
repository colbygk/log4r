# :include: rdoc/MDC
#
# == Other Info
# 
# Version:: $Id$
# Author:: Colby Gutierrez-Kraybill <colby(at)astro.berkeley.edu>

require 'monitor'

module Log4r
  MDCNAME = "log4rMDC"
  MDCNAMEMAXDEPTH = "log4rMDCMAXDEPTH"
  $globalMDCLock = Monitor.new

  # See log4r/MDC.rb
  class MDC < Monitor
    private_class_method :new

    def self.check_thread_instance()
      # need to interlock here, so that if
      # another thread is entering this section
      # of code before the main thread does,
      # then the main thread copy of the MDC
      # is setup before then attempting to clone
      # it off
      if ( Thread.current[MDCNAME] == nil ) then
	$globalMDCLock.synchronize do 
	  if ( Thread.main[MDCNAME] == nil ) then
	    Thread.main[MDCNAME] = Hash.new
	  end
	  if ( Thread.current != Thread.main ) then
	    Thread.current[MDCNAME] = Hash.new
	    Thread.main[MDCNAME].each{ |k,v| Thread.current[MDCNAME][k] = v }
	  end
	end
      end
    end

    def self.get( a_key )
      self.check_thread_instance()
      Thread.current[MDCNAME].fetch(a_key, "");
    end

    def self.get_context()
      self.check_thread_instance()
      return Thread.current[MDCNAME].clone
    end

    def self.put( a_key, a_value )
      self.check_thread_instance()
      Thread.current[MDCNAME][a_key] = a_value
    end

    def self.remove( a_key )
      self.check_thread_instance()
      Thread.current[MDCNAME].delete( a_key )
    end
  end
end
