# :include: rdoc/NDC
#
# == Other Info
# 
# Version:: $Id$
# Author:: Colby Gutierrez-Kraybill <colby(at)astro.berkeley.edu>

module Log4r
  NDCNAME = "log4rNDC"
  NDCNAMEMAXDEPTH = "log4rNDCMAXDEPTH"
  NDCDEFAULTMAXDEPTH = 256

  # See log4r/NDC.rb
  class NDC
    private_class_method :new

    def self.check_thread_instance()
      if ( Thread.current[NDCNAME] == nil ) then
	Thread.current[NDCNAME] = Array.new
	Thread.current[NDCNAMEMAXDEPTH] = NDCDEFAULTMAXDEPTH
      end
    end

    def self.clear()
      self.check_thread_instance()
      Thread.current[NDCNAME].clear
    end

    def self.clone_stack()
      self.check_thread_instance()
      return Thread.current[NDCNAME].clone
    end

    def self.get_depth()
      self.check_thread_instance()
      return Thread.current[NDCNAME].length
    end

    def self.inherit( a_stack )
      if ( a_stack.class == Array ) then
	if ( Thread.current[NDCNAME] != nil ) then
	  Thread.current[NDCNAME].clear
	  Thread.current[NDCNAME] = nil
	end
	Thread.current[NDCNAME] = a_stack
      else
	raise "Expecting Array in NDC.inherit"
      end
    end

    def self.get()
      self.check_thread_instance
      return Thread.current[NDCNAME] * " "
    end

    def self.peek()
      self.check_thread_instance()
      return Thread.current[NDCNAME].last
    end

    def self.pop()
      self.check_thread_instance()
      return Thread.current[NDCNAME].pop
    end

    def self.push( value )
      self.check_thread_instance()
      if ( Thread.current[NDCNAME].length < Thread.current[NDCNAMEMAXDEPTH] ) then
	Thread.current[NDCNAME].push( value )
      end
    end

    def self.remove()
      self.check_thread_instance()
      Thread.current[NDCNAME].clear
      Thread.current[NDCNAMEMAXDEPTH] = nil
      Thread.current[NDCNAME] = nil
    end

    def self.set_max_depth( max_depth )
      self.check_thread_instance()
      Thread.current[NDCNAMEMAXDEPTH] = max_depth
    end
  end
end

