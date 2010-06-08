# :include: ../rdoc/emailoutputter

require 'log4r/outputter/outputter'
require 'log4r/staticlogger'
require 'net/smtp'

module Log4r

  class EmailOutputter < Outputter
    attr_reader :server, :port, :domain, :acct, :authtype, :subject, :tls

    def initialize(_name, hash={})
      super(_name, hash)
      validate(hash)
      @buff = []
      begin 
	Logger.log_internal {
	  "EmailOutputter '#{@name}' running SMTP client on #{@server}:#{@port}"
	}
      rescue Exception => e
	Logger.log_internal(-2) {
	  "EmailOutputter '#{@name}' failed to start SMTP client!"
	}
	Logger.log_internal {e}
	self.level = OFF
	raise e
      end
    end

    # send out an email with the current buffer
    def flush
      synch { send_mail }
      Logger.log_internal {"Flushed EmailOutputter '#{@name}'"}
    end

    private

    def validate(hash)
      @buffsize = (hash[:buffsize] or hash['buffsize'] or 100).to_i
      @formatfirst = Log4rTools.decode_bool(hash, :formatfirst, false)
      decode_immediate_at(hash)
      validate_smtp_params(hash)
    end

    def decode_immediate_at(hash)
      @immediate = Hash.new
      _at = (hash[:immediate_at] or hash['immediate_at'])
      return if _at.nil?
      Log4rTools.comma_split(_at).each {|lname|
	level = LNAMES.index(lname)
	if level.nil?
	  Logger.log_internal(-2) do
	    "EmailOutputter: skipping bad immediate_at level name '#{lname}'"
	  end
	  next
	end
	@immediate[level] = true
      }
    end

    def validate_smtp_params(hash)
      @from = (hash[:from] or hash['from'])
      raise ArgumentError, "Must specify from address" if @from.nil?
      _to = (hash[:to] or hash['to'] or "")
      @to = Log4rTools.comma_split(_to) 
      raise ArgumentError, "Must specify recepients" if @to.empty?
      @server = (hash[:server] or hash['server'] or 'localhost')
      @port = (hash[:port] or hash['port'] or 25).to_i
      @domain = (hash[:domain] or hash['domain'] or ENV['HOSTNAME'])
      @acct = (hash[:acct] or hash['acct'])
      @passwd = (hash[:passwd] or hash['passwd'])
      @authtype = (hash[:authtype] or hash['authtype'] or :cram_md5).to_s.to_sym
      @subject = (hash[:subject] or hash['subject'] or "Message of #{$0}")
      @tls = (hash[:tls] or hash['tls'] or nil)
      @params = [@server, @port, @domain, @acct, @passwd, @authtype]
    end

    def canonical_log(event)
      synch {
	@buff.push case @formatfirst
          when true then @formatter.format event
          else event 
          end
        send_mail if @buff.size >= @buffsize or @immediate[event.level]
      }
    end

    def send_mail
      msg = 
        case @formatfirst
        when true then @buff.join 
        else @buff.collect{|e| @formatter.format e}.join 
        end

      ### build a mail header for RFC 822
      rfc822msg =
        "From: #{@from}\n" +
        "To: #{@to}\n" +
        "Subject: #{@subject}\n" +
        "Date: #{Time.now.strftime( "%a, %d %b %Y %H:%M:%S %z %Z")}\n" +
        "Message-Id: <#{"%.8f" % Time.now.to_f}@#{@domain}>\n\n" +
        "#{msg}"
  
      ### send email
      begin
  
	smtp = Net::SMTP.new( @server, @port )

        if ( @tls )

	  # >1.8.7 has smtp_tls built in, 1.8.6 requires smtp_tls
	  if RUBY_VERSION < "1.8.7" then
	    begin
	      require 'rubygems'
	      require 'smtp_tls'
	      smtp.enable_starttls if smtp.respond_to?(:enable_starttls)
	    rescue LoadError => e
	      Logger.log_internal(-2) {
	        "EmailOutputter '#{@name}' unable to load smtp_tls, needed to support TLS on Ruby versions < 1.8.7"
	      }
	      raise e
	    end
	  else # RUBY_VERSION >= 1.8.7
	    smtp.enable_starttls_auto if smtp.respond_to?(:enable_starttls_auto)
	  end

	end # if @tls

        smtp.start(@domain, @acct, @passwd, @authtype) do |s|
	  s.send_message(rfc822msg, @from, @to)
        end
      rescue Exception => e
        Logger.log_internal(-2) {
	  "EmailOutputter '#{@name}' couldn't send email!"
        }
        Logger.log_internal {e}
        self.level = OFF
        raise e
      ensure @buff.clear
      end # begin
    end # def send_mail
  end # class EmailOutputter
end # module Log4r
