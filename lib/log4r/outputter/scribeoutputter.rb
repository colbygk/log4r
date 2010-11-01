# :nodoc:
# Version:: $Id$

require "log4r/outputter/outputter"
require "scribe"

module Log4r
  class ScribeOutputter < Outputter
    def initialize(_name, _host, _port, hash={})
      super(_name, hash)
      @client = Scribe.new("#{_host}:#{_port}", category=_name, add_newlines=false)
    end

    private

    def write(data)
      puts "data=#{data}"
      @client.log(data.strip)
    end
  end
end
