# :include: rdoc/GDC
#
# == Other Info
# 
# Version:: $Id$
# Author:: Colby Gutierrez-Kraybill <colby(at)astro.berkeley.edu>

require 'monitor'

module Log4r
  GDCNAME = "log4rGDC"
  
  # See log4r/GDC.rb
  class GDC < Monitor
    
    def initialize()
      synchronize do
	if ( Thread.main != Thread.current ):
	  raise "Can only initialize Global Diagnostic Context from Thread.main" 
	end
      end
    end

    def clear()
      initialize()
      synchronize do
	Thread.main[GDCNAME] = ""
      end
    end

    def set( a_name )
      initialize()
      synchronize do
	Thread.main[GDCNAME] = a_name
      end
    end

  end
end

