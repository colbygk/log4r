# :nodoc:
# Version:: $Id$

require "log4r/outputter/outputter"
require "rubygems"
require "scribe"

module Log4r
  class ScribeOutputter < Outputter
    attr_reader :host, :port

    def initialize(_name, hash={})
      super(_name, hash)
      @host = hash[:host]
      @port = hash[:port]
      @client = Scribe.new("#{@host}:#{@port}", category=_name, add_newlines=false)
    end

    private

    def write(data)
      begin
        @client.log(data)
      rescue ScribeThrift::Client::TransportException => e
        Logger.log_internal(-2) {
          "Caught TransportException, is the scribe server alive?"
        }
      rescue ThriftClient::NoServersAvailable => e
        Logger.log_internal(-2) {
          "No scribe servers are available!"
        }
      end
    end
  end
end
