# :nodoc:
require "rubygems"
require 'logger'
require "log4r/outputter/outputter"
require 'bunny'
require 'yaml'

module Log4r
  # See log4r/logserver.rb
  class RabbitOutputter < Outputter

    def initialize(_name, hash={})
      # Configuration defaults
      super(_name, hash)
      @path_to_yaml_file = "#{Rails.root}/config/rabbitmq.yml"
      @config = {:host => 'localhost'}
      if File.exist? @path_to_yaml_file
        if settings = YAML::load(IO.read(@path_to_yaml_file))
          env_settings = settings.include?(Rails.env) ? settings[Rails.env] : settings
          @config.merge!(env_settings)
          @config.symbolize_keys!
          @queue_name = @config.delete(:queue) || ''
          start_bunny rescue nil
        else
          stderr_log "Malformed configuration file [#{@path_to_yaml_file}]"
        end
      else
        stderr_log "Unable to find rabbit configuration file [#{@path_to_yaml_file}]"
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
    
    private

    def write(data)
      @queue.publish data, { routing_key: @queue.name } if @conn.connected? and @queue
    rescue Exception => e
      @conn.send(:handle_network_failure, e)
      create_channel if @conn.connected?
    end

  end
end
