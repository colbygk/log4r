# :nodoc:
require "rubygems"
require 'logger'
require "log4r/outputter/outputter"
require 'bunny'
require 'yaml'
require 'stringio'

module Log4r
  # See log4r/logserver.rb
  class RabbitOutputter < Outputter

    def initialize(_name, hash={})
      # Configuration defaults
      super(_name, hash)
      stderr_log "Unable to find rabbit configuration file" unless load_config
      @config ||= {:host => "localhost"}
      @config.symbolize_keys!
      @queue_name = @config.delete(:queue) || ''
      init_buffer
      start_bunny rescue nil
    end

    def load_config_file(name)
      path = "#{Rails.root}/config/#{name}"
      if File.exist?(path)
        @config = YAML::load(IO.read(path))
      end
    end

    def load_config
      @config = if load_config_file("bunny.yml")
        @config[Rails.env]
      else
        load_config_file("rabbitmq.yml")
      end
    end

    def start_bunny
      begin
        stderr_log "Starting Bunny Client"
        config = @config.clone
        config[:pass] &&= "**redacted**"
        stderr_log config
        @conn = Bunny.new @config
        @conn.start
        create_channel
      rescue Bunny::TCPConnectionFailed => e
        stderr_log "rescued from: #{e}. Unable to connect to Rabbit Server"
      end
    end

    def stderr_log(msg)
      $stderr.puts "[#{Time.now.utc}] #{msg}"
    end

    def create_channel
      ch = @conn.create_channel
      @queue  = ch.queue(@queue_name, auto_delete: false, durable: true)
    end

    def flush
      @queue.publish(read_buffer, { routing_key: @queue.name }) if @conn.connected? and @queue
      init_buffer
    rescue Exception => e
      @conn.send(:handle_network_failure, e)
      create_channel if @conn.connected?
    end

    private

    def init_buffer
      @buffered_data = StringIO.new
    end

    def write(data)
      stripped = data.gsub(/\s+$/,'')
      return if stripped.empty?
      @buffered_data.write("#{stripped}\n")
    end

    def read_buffer
      @buffered_data.string
    end

  end
end
