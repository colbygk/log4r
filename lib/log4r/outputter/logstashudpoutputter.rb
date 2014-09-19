# :include: ../rdoc/outputter
#
# == Other Info
#
# Version:: $Id$
# Author:: Marcelo Gornstein <marcelog@gmail.com>

require "log4r/outputter/outputter"
require 'log4r/staticlogger'
require "socket"
require "date"

module Log4r

  class LogstashUDPOutputter < Outputter
    attr_reader :host, :port
    attr_accessor :udpsock
     
    def initialize(_name, hash={})
      super(_name, hash)
      @host = (hash[:hostname] or hash["hostname"])
      @port = (hash[:port] or hash["port"])
      @log_type = (hash[:log_type] or hash["log_type"])
      begin 
        Logger.log_internal {
          "LogstashUDPOutputter will send to #{@host}:#{@port}"
        }
        @udpsock = UDPSocket.new
        @udpsock.connect( @host, @port )
      rescue Exception => e
        Logger.log_internal(ERROR) {
          "UDPOutpLogstashUDPOutputterutter failed to create UDP socket: #{e}"
        }
        Logger.log_internal {e}
        self.level = OFF
        raise e
      end
    end

    #######
    private
    #######

    def canonical_log(logevent)
      l = LNAMES[logevent.level]
      payload = {
        "@timestamp" => DateTime.now.to_time.utc.strftime("%FT%T%z"),
        "message" => format(logevent),
        "type" => @log_type,
        "fields" => {
          "level" => l
        }
      }
      @udpsock.send(payload.to_json, 0)
      rescue Exception => e
        Logger.log_internal(ERROR) {
          "LogstashUDPOutputter failed to send data to #{@host}:#{@port}, #{e}"
        }
    end
  end
end
