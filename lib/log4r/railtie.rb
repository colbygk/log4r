# :nodoc:
# Version:: $Id$
# Author:: Mike Ho <i(at)bestmike007.com>
# How to configure log4r for rails in application.rb:
# config.log4r.<option> = <value>
# config.log4r.enabled = true # enable log4r integration
# config.log4r.action_mht = 500 # maximum action handling time to log with level INFO, default: 500ms.
# config.log4r.auto_reload = true # auto-reload log4r configuration file from config/log4r.yaml (or config/log4r-production.yaml in production environment)

require 'rails'
require 'log4r/yamlconfigurator'

module Log4r

  class Railtie < Rails::Railtie
    
    config.log4r = ActiveSupport::OrderedOptions.new
    # default values
    config.log4r.enabled = false
    config.log4r.action_mht = 500
    config.log4r.auto_reload = true

    initializer "log4r.pre_init", :before => :initialize_logger do |app|
      if app.config.log4r.enabled
        Log4r::Railtie.load_config
        Log4r::Railtie.pre_init(app, {:root => Rails.root.to_s, :env => Rails.env}.merge(app.config.log4r))
      end
    end

    initializer "log4r.post_init", :after => :initialize_logger do |app|
      if app.config.log4r.enabled
        Log4r::Railtie.post_init
      end
    end

    initializer "log4r.cache_logger", :after => :initialize_cache do |app|
      if app.config.log4r.enabled
        Rails.cache.extend Module.new {
          @@custom_logger
          def logger
            Log4r::Logger['rails::cache'] || Log4r::Logger.root
          end
          def logger=(l)
            (l || logger).debug "Log4r is preventing set of logger."
          end
        }
      end
    end
    
    # load or reload config from RAILS_ROOT/config/log4r.yaml or RAILS_ROOT/config/log4r-production.yaml
    @@config_time = Time.new 0
    @@config_next_check = Time.new 0
    @@config_path = nil
    def self.load_config
      # auto reload config every 30 seconds.
      return if Time.now < @@config_next_check
      @@config_next_check = Time.now + 30
      return  if !@@config_path.nil? && (!File.file?(@@config_path) || File.mtime(@@config_path) == @@config_time)
      config_path = File.join Rails.root, "config", "log4r.yaml"
      begin
        if Rails.env == 'production'
          production_config = File.join Rails.root, "config", "log4r-production.yaml"
          config_path = production_config if File.file?(production_config)
        end
        if File.file? config_path
          YamlConfigurator.load_yaml_file config_path
          @@config_path = config_path
          @@config_time = File.mtime(config_path)
          return
        end
        puts "Log4r Warning: Unable to find log4r config file for rails, using default config."
      rescue Log4r::ConfigError => e
        puts "Log4r Error: Unable to load config #{config_path}, error: #{e}. Using default config."
      end
      config_path = File.join File.dirname(__FILE__), 'log4r-rails.yaml'
      YamlConfigurator.load_yaml_file config_path
    end
    
    def self.pre_init(app, opts)
      @@app = app
      @@options = opts
      # silence default rails logger
      app.config.log_level = :unknown
      # define global logger
      self.setup_logger Object, "root"
      # define rails controller logger names
      self.setup_logger ActionController::Base, "rails::controllers"
      self.setup_logger ActiveRecord::Base, "rails::models"
      self.setup_logger ActionMailer::Base, "rails::mailers"
      
      self.remove_existing_log_subscriptions
      
      ActiveSupport::Notifications.subscribe "process_action.action_controller" do |name, start, finish, id, payload|
        Log4r::Railtie.load_config if Log4r::Railtie.options[:auto_reload]
        Log4r::Railtie.controller_log({ duration: ((finish - start).to_f * 100000).round / 100.0 }.merge(payload))
      end
      
      ActiveSupport::Notifications.subscribe "sql.active_record" do |name, start, finish, id, payload|
        Log4r::Railtie.load_config if Log4r::Railtie.options[:auto_reload]
        logger = Log4r::Logger["rails::db"] || Log4r::Logger.root
        logger.debug { "(#{((finish - start).to_f * 100000).round / 100.0 }) #{payload[:sql]}" }
      end
    end
    
    def self.post_init
      self.setup_logger Rails, "rails"
      # fix rails server stdout formatter issue
      Rails.logger.extend Module.new {
        def formatter
          nil
        end
      }
      # disable rack development output, e.g. Started GET "/session/new" for 127.0.0.1 at 2012-09-26 14:51:42 -0700
      if Rails.const_defined?(:Rack) && Rails::Rack.const_defined?(:Logger)
        self.setup_logger Rails::Rack::Logger, "root"
      end
      # override DebugExceptions output
      ActionDispatch::DebugExceptions.module_eval %-
        def log_error(env, wrapper)
          logger = Rails.logger
          exception = wrapper.exception
          # trace = wrapper.application_trace
          # trace = wrapper.framework_trace if trace.empty?
          logger.info "ActionDispatch Exception: \#{exception.class} (\#{exception.message})"
        end
        private :log_error
      -
    end
    
    # remove rails default log subscriptions
    # [ActiveRecord::LogSubscriber, ActionController::LogSubscriber, ActionView::LogSubscriber, ActionMailer::LogSubscriber] 
    def self.remove_existing_log_subscriptions
      ActiveSupport::LogSubscriber.log_subscribers.each do |subscriber|
        case subscriber
        when ActionView::LogSubscriber
          unsubscribe(:action_view, subscriber)
        when ActionController::LogSubscriber
          unsubscribe(:action_controller, subscriber)
        when ActiveRecord::LogSubscriber
          unsubscribe(:active_record, subscriber)
        when ActionMailer::LogSubscriber
          unsubscribe(:action_mailler, subscriber)
        end
      end
    end
    def self.unsubscribe(component, subscriber)
      events = subscriber.public_methods(false).reject { |method| method.to_s == 'call' }
      events.each do |event|
        ActiveSupport::Notifications.notifier.listeners_for("#{event}.#{component}").each do |listener|
          if listener.instance_variable_get('@delegate') == subscriber
            ActiveSupport::Notifications.unsubscribe listener
          end
        end
      end
    end
    
    def self.options
      @@options
    end
    
    def self.controller_log(payload)
      logger = Rails.logger
      params_logger = Log4r::Logger["rails::params"] || Loger4r::Logger.root
      
      duration = payload[:duration]
      unless payload[:exception].nil?
        logger.warn {
          db = (payload[:db_runtime] * 100).round/100.0 rescue "-"
          view = (payload[:view_runtime] * 100).round/100.0 rescue "-"
          "#{payload[:method]} #{payload[:path]} (TIMING[ms]: sum:#{duration} db:#{db} view:#{view}) EXCEPTION: #{payload[:exception]}"
        }
        params_logger.info { "request params: " + payload[:params].to_json }
        return
      end
      if duration >= Log4r::Railtie.options[:action_mht]
        logger.warn {
          db = (payload[:db_runtime] * 100).round/100.0 rescue "-"
          view = (payload[:view_runtime] * 100).round/100.0 rescue "-"
          "#{payload[:method]} #{payload[:path]} (TIMING[ms]: sum:#{duration} db:#{db} view:#{view})"
        }
      else
        logger.info {
          db = (payload[:db_runtime] * 100).round/100.0 rescue "-"
          view = (payload[:view_runtime] * 100).round/100.0 rescue "-"
          "#{payload[:method]} #{payload[:path]} (TIMING[ms]: sum:#{duration} db:#{db} view:#{view})"
        }
      end
      params_logger.info { "request params: " + payload[:params].to_json }
    end
    
    # convenient static method to setup logger for class and descendants.
    def self.setup_logger(clazz, logger_name)
      clazz.module_eval %(
        @@custom_logger = nil
        def self.logger
          @@custom_logger || Log4r::Logger['#{logger_name}'] || Log4r::Logger.root
        end
        def self.logger=(l)
          (l || @@custom_logger).debug "Log4r is preventing set of logger. Use #custom_logger= if you really want it set."
        end
        def self.custom_logger=(l)
          @@custom_logger = l
        end
        def logger
          #{clazz.inspect}.logger
        end
      )
    end
    
  end # class Railtie
  
end # module Log4r
