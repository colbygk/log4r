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
      @client.log(data.strip)
    end
  end
end
