# :include: ../rdoc/log4jxmlformatter
#
# == Other Info
#
# Version:: $Id$

require "log4r/formatter/formatter"

require "rubygems"
begin
  require "builder"
rescue LoadError
  puts "builder gem is required to use log4jxmlformatter, i.e. gem install builder"
end

module Log4r

  class Log4jXmlFormatter < BasicFormatter
    
    def format(logevent)
      logger = logevent.fullname.gsub('::', '.')
      timestamp = (Time.now.to_f * 1000).to_i
      level = LNAMES[logevent.level]
      message = format_object(logevent.data)
      exception = message if logevent.data.kind_of? Exception
      file, line, method = parse_caller(logevent.tracer[0]) if logevent.tracer
      
      builder = Builder::XmlMarkup.new
      xml = builder.log4j :event, :logger => logger,
                                  :timestamp => timestamp,
                                  :level => level,
                                  :thread => '' do |e|
              e.log4j :NDC, NDC.get
              e.log4j :message, message
              e.log4j :throwable, exception if exception
              e.log4j :locationInfo, :class => '',
                                     :method => method,
                                     :file => file,
                                     :line => line
              e.log4j :properties do |p|
                MDC.get_context.each do |key, value|
                  p.log4j :data, :name => key, :value => value
                end
              end
            end
      xml
    end

    #######
    private
    #######

    def parse_caller(line)
      if /^(.+?):(\d+)(?::in `(.*)')?/ =~ line
        file = Regexp.last_match[1]
        line = Regexp.last_match[2].to_i
        method = Regexp.last_match[3]
        [file, line, method]
      else
        []
      end
    end
  end

end
