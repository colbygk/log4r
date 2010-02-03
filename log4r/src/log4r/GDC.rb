# :include: rdoc/GDC
#
# == Other Info
# 
# Version:: $Id$
# Author:: Colby Gutierrez-Kraybill <colby(at)astro.berkeley.edu>

require 'monitor'

module Log4r
  GDCNAME = "log4rGDC"
  $globalGDCLock = Monitor.new

  # See log4r/GDC.rb
  class GDC < Monitor
    private_class_method :new

    def self.clear()
      Thread.main[GDCNAME] = ""
    end

    def self.get()
      $globalGDCLock.synchronize do
	if ( Thread.main[GDCNAME] == nil ) then
	  Thread.main[GDCNAME] = $0
	end
      end
      return Thread.main[GDCNAME]
    end

    def self.set( a_name )
      if ( Thread.current != Thread.main ) then
	raise "Can only initialize Global Diagnostic Context from Thread.main" 
      end
      $globalGDCLock.synchronize do
	Thread.main[GDCNAME] = a_name
      end
    end
  end
end

