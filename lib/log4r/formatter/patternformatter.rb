# :include: ../rdoc/patternformatter
#
# == Other Info
#
# Version:: $Id$

require "log4r/formatter/formatter"
require "log4r/GDC"
require "log4r/MDC"
require "log4r/NDC"
  
module Log4r
  # See log4r/formatter/patternformatter.rb
  class PatternFormatter < BasicFormatter
  
    # Arguments to sprintf keyed to directive letters<br>
    # %c - event short name<br>
    # %C - event fullname<br>
    # %d - date<br>
    # %g - Global Diagnostic Context (GDC)<br>
    # %t - trace<br>
    # %m - message<br>
    # %h - thread name<br>
    # %p - process ID aka PID<br>
    # %M - formatted message<br>
    # %l - Level in string form<br>
    # %x - Nested Diagnostic Context (NDC)<br>
    # %X - Mapped Diagnostic Context (MDC), syntax is "%X{key}"<br>
    # %% - Insert a %<br>
    DirectiveTable = {
      "c" => 'event.name',
      "C" => 'event.fullname',
      "d" => 'format_date',
      "g" => 'Log4r::GDC.get()',
      "t" => '(event.tracer.nil? ? "no trace" : event.tracer[0])',
      "T" => '(event.tracer.nil? ? "no trace" : event.tracer[0].split(File::SEPARATOR)[-1])',
      "m" => 'event.data',
      "h" => '(Thread.current[:name] or Thread.current.to_s)',
      "p" => 'Process.pid.to_s',
      "M" => 'format_object(event.data)',
      "l" => 'LNAMES[event.level]',
      "x" => 'Log4r::NDC.get()',
      "X" => 'Log4r::MDC.get("DTR_REPLACE")',
      "%" => '"%"'
    }
  
    # Matches the first directive encountered and the stuff around it.
    #
    # * $1 is the stuff before directive or "" if not applicable
    # * $2 is the directive group or nil if there's none
    # * $3 is the %#.# match within directive group
    # * $4 is the .# match which we don't use (it's there to match properly)
    # * $5 is the directive letter
    # * $6 is the stuff after the directive or "" if not applicable
    # * $7 is the remainder
  
    DirectiveRegexp = /([^%]*)((%-?\d*(\.\d+)?)([cCdgtTmhpMlxX%]))?(\{.+?\})?(.*)/
  
    # default date format
    ISO8601 = "%Y-%m-%d %H:%M:%S"
    
    attr_reader :pattern, :date_pattern, :date_method
  
    # Accepts the following hash arguments (either a string or a symbol):
    #
    # [<tt>pattern</tt>]         A pattern format string.
    # [<tt>date_pattern</tt>]    A Time#strftime format string. See the
    #                            Ruby Time class for details.
    # [+date_method+]     
    #   As an option to date_pattern, specify which
    #   Time.now method to call. For 
    #   example, +usec+ or +to_s+.
    #   Specify it as a String or Symbol.
    #
    # The default date format is ISO8601, which looks like this:
    # 
    #   yyyy-mm-dd hh:mm:ss    =>    2001-01-12 13:15:50
  
    def initialize(hash={})
      super(hash)
      @pattern = (hash['pattern'] or hash[:pattern] or nil)
      @date_pattern = (hash['date_pattern'] or hash[:date_pattern] or nil)
      @date_method = (hash['date_method'] or hash[:date_method] or nil)
      @date_pattern = ISO8601 if @date_pattern.nil? and @date_method.nil?
      PatternFormatter.create_format_methods(self)
    end

    # PatternFormatter works by dynamically defining a <tt>format</tt> method
    # based on the supplied pattern format. This method contains a call to 
    # Kernel#sptrintf with arguments containing the data requested in
    # the pattern format.
    #
    # How is this magic accomplished? First, we visit each directive
    # and change the %#.# component to  %#.#s. The directive letter is then 
    # used to cull an appropriate entry from the DirectiveTable for the
    # sprintf argument list. After assembling the method definition, we
    # run module_eval on it, and voila.
    
    def PatternFormatter.create_format_methods(pf) #:nodoc:
      # first, define the format_date method
      if pf.date_method
        module_eval "def pf.format_date; Time.now.#{pf.date_method}; end"
      else
        module_eval <<-EOS
          def pf.format_date
            Time.now.strftime "#{pf.date_pattern}"
          end
        EOS
      end
      # and now the main format method
      ebuff = "def pf.format(event)\n sprintf(\""
      _pattern = pf.pattern.dup
      args = [] # the args to sprintf which we'll append to ebuff lastly
      while true # work on each match in turn
        match = DirectiveRegexp.match _pattern
        ebuff << match[1] unless match[1].empty?
        break if match[2].nil?
        # deal with the directive by inserting a %#.#s where %#.# is copied
        # directy from the match
        ebuff << match[3] + "s"

	if ( match[5] == 'X' && match[6] != nil ) then

	  # MDC matches, need to be able to handle String, Symbol or Number
	  match6sub = /[\{\}\"]/
	  mdcmatches = match[6].match /\{(:?)(\d*)(.*)\}/

	  if ( mdcmatches[1] == "" && mdcmatches[2] == "" )
	    match6sub = /[\{\}]/ # don't remove surrounding "'s if String
	  end
	  
	  args <<
	    DirectiveTable[match[5]].gsub("DTR_REPLACE", match[6]).gsub(match6sub,'')
	else
	  args << DirectiveTable[match[5]]  # cull the data for our argument list
	end
        break if match[7].empty?
        _pattern = match[7]
      end
      ebuff << '\n", ' + args.join(', ') + ")\n"
      ebuff << "end\n"
      module_eval ebuff
    end
  end
end
