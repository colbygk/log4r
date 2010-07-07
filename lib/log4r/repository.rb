# :nodoc:
# Version:: $Id$
#
# Using Thread.exclusive seems to be more efficient than using
# a class wide instance of Sync.synchronize in ruby 1.8.6 - Colby
#
# Using Sync.synchronize, 5000 iterations:
# real	3m55.493s user	3m45.557s sys	0m3.478s
#
# Using Thread.exclusive, 5000 iterations:
# real	2m35.859s user	2m33.951s sys	0m1.224s
#

require 'monitor'
require "singleton"

module Log4r
  class Logger

    # The repository stores a Hash of loggers keyed to their fullnames and
    # provides a few functions to reduce the code bloat in log4r/logger.rb.
    # This class is supposed to be transparent to end users, hence it is
    # a class within Logger. If anyone knows how to make this private,
    # let me know.

    class Repository # :nodoc:
      extend MonitorMixin
      include Singleton
      attr_reader :loggers

      def initialize
	@loggers = Hash.new
      end

      def self.[](fullname)
	self.synchronize do
	  instance.loggers[fullname]
	end # exclusive
      end

      def self.[]=(fullname, logger)
	self.synchronize do
	  instance.loggers[fullname] = logger
	end # exclusive
      end

      # Retrieves all children of a parent
      def self.all_children(parent)
	# children have the parent name + delimiter in their fullname
	daddy = parent.name + Private::Config::LoggerPathDelimiter
	self.synchronize do
	  for fullname, logger in instance.loggers
	    yield logger if parent.is_root? || fullname =~ /#{daddy}/
	  end
	end # exclusive
      end

      # when new loggers are introduced, they may get inserted into
      # an existing inheritance tree. this method
      # updates the children of a logger to link their new parent
      def self.reassign_any_children(parent)
	self.synchronize do
	  for fullname, logger in instance.loggers
	    next if logger.is_root?
	    logger.parent = parent if logger.path =~ /^#{parent.fullname}$/
	  end
	end # exclusive
      end

      # looks for the first defined logger in a child's path 
      # or nil if none found (which will then be rootlogger)
      def self.find_ancestor(path)
	arr = path.split Log4rConfig::LoggerPathDelimiter
	logger = nil
	self.synchronize do
	  while arr.size > 0 do
	    logger = Repository[arr.join(Log4rConfig::LoggerPathDelimiter)]
	    break unless logger.nil?
	    arr.pop
	  end
	end # exclusive
	logger
      end

    end # class Repository
  end # class Logger
end # Module Log4r

