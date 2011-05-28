# :include: ../rdoc/outputter
#
# == Other Info
#
# Version:: $Id$
# Author:: Leon Torres <leon@ugcs.caltech.edu>

require "log4r/outputter/outputter"
require 'log4r/staticlogger'
require "socket"

module Log4r

  class UDPOutputter < Outputter
    attr_reader :host, :port
    attr_accessor :udpsock
     
    def initialize(_name, hash={})
      super(_name, hash)
      @host = (hash[:hostname] or hash["hostname"])
      @port = (hash[:port] or hash["port"])

      begin 
	Logger.log_internal {
	  "UDPOutputter will send to #{@host}:#{@port}"
	}
	@udpsock = UDPSocket.new
	@udpsock.connect( @host, @port )
      rescue Exception => e
	Logger.log_internal(ERROR) {
	  "UDPOutputter failed to create UDP socket: #{e}"
	}
	Logger.log_internal {e}
	self.level = OFF
	raise e
      end
    end

    #######
    private
    #######

    def write(data)
      @udpsock.send(data, 0)
    rescue Exception => e
      Logger.log_internal(ERROR) {
	"UDPOutputter failed to send data to #{@host}:#{@port}, #{e}"
      }
    end
    
  end

end
