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

  # See log4r/MDC.rb
  class MDC < Monitor

    def initialize()
      synchronize do
	if ( Thread.current[MDCNAME] == nil ):
	  Thread.current[MDCNAME] = Hash.new
	end
      end
    end

    def get( a_key )
      initialize()
      synchronize do
	Thread.current[MDCNAME].fetch(a_key, nil);
      end
    end

    def get_context()
      initialize()
      synchronized do
	return Thread.current[MDCNAME].clone
      end
    end

    def put( a_key, a_value )
      initialize()
      synchronized do
	return Thread.current[MDCNAME].length
      end
    end

    def inherit( a_stack )
      synchronized do
	if ( a_stack.class == Array ):
	  Thread.current[MDCNAME] = a_stack
	else
	  raise "Expecting Array in MDC.inherit"
	end
      end
    end

    def peek()
      initialize()
      synchronized do
	return Thread.current[MDCNAME].last
      end
    end

    def pop()
      initialize()
      synchronized do
	return Thread.current[MDCNAME].pop
      end
    end

    def remove( a_key )
      initialize()
      synchronized do
	Thread.current[MDCNAME].delete( a_key )
      end
    end
  end
end

