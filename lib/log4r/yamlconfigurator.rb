# :include: rdoc/yamlconfigurator
#
# == Other Info
#
# Version: $Id$

require "log4r/logger"
require "log4r/outputter/staticoutputter"
require "log4r/logserver"
require "log4r/outputter/remoteoutputter"

require 'yaml'

module Log4r
  # Gets raised when Configurator encounters bad YAML.
  class ConfigError < Exception
  end

  # See log4r/yamlconfigurator.rb
  class YamlConfigurator
    @@params = Hash.new

    # Get a parameter's value
    def self.[](param); @@params[param] end
    # Define a parameter with a value
    def self.[]=(param, value); @@params[param] = value end


    def self.custom_levels( levels)
      return Logger.root if levels.size == 0
      for i in 0...levels.size
        name = levels[i].to_s
        if name =~ /\s/ or name !~ /^[A-Z]/
          raise TypeError, "#{name} is not a valid Ruby Constant name", caller
        end
      end
      Log4r.define_levels *levels
    end

    # Given a filename, loads the YAML configuration for Log4r.
    def self.load_yaml_file( filename)
      actual_load( File.open( filename))
    end

    # You can load a String YAML configuration instead of a file.
    def self.load_yaml_string( string)
      actual_load( string)
    end

    #######
    private
    #######

    def self.actual_load( yaml_docs)
      log4r_config = nil
      YAML.load_documents( yaml_docs){ |doc|
        doc.has_key?( 'log4r_config') and log4r_config = doc['log4r_config'] and break
      }
      if log4r_config.nil?
        raise ConfigError, 
        "Key 'log4r_config:' not defined in yaml documents", caller[1..-1]
      end
      decode_yaml( log4r_config)
    end
    
    def self.decode_yaml( cfg)
      decode_pre_config( cfg['pre_config'])
      cfg['outputters'].each{ |op| decode_outputter( op)}
      cfg['loggers'].each{ |lo| decode_logger( lo)}
      cfg['logserver'].each{ |lo| decode_logserver( lo)} unless cfg['logserver'].nil?
    end

    def self.decode_pre_config( pre)
      return Logger.root if pre.nil?
      decode_custom_levels( pre['custom_levels'])
      global_config( pre['global'])
      global_config( pre['root'])
      decode_parameters( pre['parameters'])
    end

    def self.decode_custom_levels( levels)
      return Logger.root if levels.nil?
      begin custom_levels( levels)
      rescue TypeError => te
        raise ConfigError, te.message, caller[1..-4]
      end
    end
    
    def self.global_config( e)
      return if e.nil?
      globlev = e['level']
      return if globlev.nil?
      lev = LNAMES.index(globlev)     # find value in LNAMES
      Log4rTools.validate_level(lev, 4)  # choke on bad level
      Logger.global.level = lev
    end

    def self.decode_parameters( params)
      params.each{ |p| @@params[p['name']] = p['value']} unless params.nil?
    end

    def self.decode_outputter( op)
      # fields
      name = op['name']
      type = op['type']
      level = op['level']
      only_at = op['only_at']
      # validation
      raise ConfigError, "Outputter missing name", caller[1..-3] if name.nil?
      raise ConfigError, "Outputter missing type", caller[1..-3] if type.nil?
      Log4rTools.validate_level(LNAMES.index(level)) unless level.nil?
      only_levels = []
      unless only_at.nil?
        for lev in only_at
          alev = LNAMES.index(lev)
          Log4rTools.validate_level(alev, 3)
          only_levels.push alev
        end
      end

      formatter = decode_formatter( op['formatter'])

      opts = {}
      opts[:level] = LNAMES.index(level) unless level.nil?
      opts[:formatter] = formatter unless formatter.nil?
      opts.merge!(decode_hash_params(op))
      begin
        Outputter[name] = Log4r.const_get(type).new name, opts
      rescue Exception => ae
        raise ConfigError, 
        "Problem creating outputter: #{ae.message}", caller[1..-3]
      end
      Outputter[name].only_at( *only_levels) if only_levels.size > 0
      Outputter[name]
    end

    def self.decode_formatter( fo)
      return nil if fo.nil?
      type = fo['type'] 
      raise ConfigError, "Formatter missing type", caller[1..-4] if type.nil?
      begin
        return Log4r.const_get(type).new(decode_hash_params(fo))
      rescue Exception => ae
        raise ConfigError,
        "Problem creating outputter: #{ae.message}", caller[1..-4]
      end
    end

    ExcludeParams = %w{formatter level name type only_at}

    # Does the fancy parameter to hash argument transformation
    def self.decode_hash_params(ph)
      case ph
      when Hash
        ph.inject({}){|a,(k,v)| a[k] = self.decode_hash_params(v); a}
      when Array
        ph.map{|v| self.decode_hash_params(v)}
      when String
        self.paramsub(ph)
      else
        ph
      end
    end

    # Substitues any #{foo} in the YAML with Parameter['foo']
    def self.paramsub(str)
      @@params.each {|param, value|
        str = str.sub("\#{#{param}}", value)
      }
      str
    end

    def self.decode_logger( lo)
      l = Logger.new lo['name']
      decode_logger_common( l, lo)
    end

    def self.decode_logserver( lo)
      name = lo['name']
      uri  = lo['uri']
      l = LogServer.new name, uri
      decode_logger_common(l, lo)
    end

    def self.decode_logger_common( l, lo)
      level    = lo['level']
      additive = lo['additive']
      trace    = lo['trace']
      l.level    = LNAMES.index( level) unless level.nil?
      l.additive = additive unless additive.nil?
      l.trace    = trace unless trace.nil?
      # and now for outputters
      outs = lo['outputters']
      outs.each {|n| l.add n.strip} unless outs.nil?
    end
  end
end

