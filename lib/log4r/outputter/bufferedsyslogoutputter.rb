require 'log4r/outputter/syslogoutputter'

module Log4r
  class BufferedSyslogOutputter < SyslogOutputter

    def initialize(*args)
      super
      @buff = {}
    end

    def flush
      synch do
        begin
          @buff.each do |pri, message|
            Syslog.open(@ident, @logopt, @facility) do |s|
              s.log(pri, '%s', message.join("\t"))
            end
          end
        ensure
          @buff.clear
        end
      end
    end

    private

    def canonical_log(logevent)
      begin
        pri = SYSLOG_LEVELS_MAP[@levels_map[LNAMES[logevent.level]]]
      rescue
        pri = LOG_INFO
      end

      return if logevent.data.empty?

      o = format(logevent)
      msg = if o.is_a? Exception
              "#{o.class} at (#{o.backtrace[0]}): #{o.message}"
            elsif o.respond_to?(:to_str)
              o.to_str
            else
              o.inspect
            end
      synch { @buff.has_key?(pri) ? @buff[pri].push(msg) : @buff[pri] = [msg] }
    end
  end
end
