# :include: rdoc/NDC
#
# == Other Info
# 
# Version:: $Id$
# Author:: Colby Gutierrez-Kraybill <colby(at)astro.berkeley.edu>

require 'monitor'

module Log4r
  NDCNAME = "log4rNDC"
  NDCNAMEMAXDEPTH = "log4rNDCMAXDEPTH"
  NDCDEFAULTMAXDEPTH = 100
  
  # See log4r/NDC.rb
  class NDC < Monitor
    
    def initialize()
      synchronize do
	if ( Thread.current[NDCNAME] == nil ):
	  Thread.current[NDCNAME] = Array.new
	  Thread.current[NDCNAMEMAXDEPTH] = NDCDEFAULTMAXDEPTH
	end
      end
    end

    def clear()
      initialize()
      synchronize do
	Thread.current[NDCNAME].clear
      end
    end

    def clone_stack()
      initialize()
      synchronized do
	return Thread.current[NDCNAME].clone
      end
    end

    def get_depth()
      initialize()
      synchronized do
	return Thread.current[NDCNAME].length
      end
    end

    def inherit( a_stack )
      synchronized do
	if ( a_stack.class == Array ):
	  Thread.current[NDCNAME] = a_stack
	else
	  raise "Expecting Array in NDC.inherit"
	end
      end
    end

    def peek()
      initialize()
      synchronized do
	return Thread.current[NDCNAME].last
      end
    end

    def pop()
      initialize()
      synchronized do
	return Thread.current[NDCNAME].pop
      end
    end

    def push( value )
      initialize()
      synchronized do
	if ( Thread.current[NDCNAME].length < Thread.current[NDCNAMEMAXDEPTH] ):
	  Thread.current[NDCNAME].push( value )
	end
      end
    end

    def remove()
      synchronized do
	if ( Thread.current[NDCNAME] != nil ):
	  Thread.current[NDCNAME].remove
	  Thread.current[NDCNAMEMAXDEPTH] = nil
	  Thread.current[NDCNAME] = nil
	end
      end
    end

    def set_max_depth( max_depth )
      initialize()
      synchronized do
	Thread.current[NDCNAMEMAXDEPTH] = max_depth
      end
    end
  end
end

