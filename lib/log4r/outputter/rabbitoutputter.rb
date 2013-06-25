# :nodoc:
require "rubygems"
require "log4r/outputter/outputter"
require 'bunny'

module Log4r
  # See log4r/logserver.rb
  class RabbitOutputter < Outputter

    def initialize(_name, hash={})
      super(_name, hash)
        conn = Bunny.new(user:'seanet', pass:'s34Ch1ck3n', vhost:'/seanet', host:'rabbit.mtnsatcloud.com')
        conn.start

        ch = conn.create_channel
        @q  = ch.queue('seanet_logs', auto_delete: false, durable: true)
    end

    private

    def write(data)
      @q.publish(data, :routing_key => @q.name)
    end
  end
end

