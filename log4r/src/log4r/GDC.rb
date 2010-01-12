# :include: rdoc/GDC
#
# == Other Info
# 
# Version:: $Id$
# Author:: Colby Gutierrez-Kraybill <colby(at)astro.berkeley.edu>

module Log4r
  GDCNAME = "log4rGDC"

  # See log4r/GDC.rb
  class GDC
    private_class_method :new

    def self.check_thread_instance()
      if ( Thread.main != Thread.current ):
	raise "Can only initialize Global Diagnostic Context from Thread.main" 
      else
	if ( Thread.main[GDCNAME] == nil ):
	  Thread.main[GDCNAME] = $0
	end
      end
    end

    def self.clear()
      check_thread_instance()
    end

    def self.get()
      check_thread_instance()
      return Thread.main[GDCNAME]
    end

    def self.set( a_name )
      check_thread_instance()
      Thread.main[GDCNAME] = a_name
    end
  end
end

