# :nodoc:
# Version:: $Id$

require "log4r/outputter/iooutputter"
require "log4r/staticlogger"

module Log4r

  # Convenience wrapper for File. Additional hash arguments are:
  #
  # [<tt>:filename</tt>]   Name of the file to log to.
  # [<tt>:trunc</tt>]      Truncate the file?
  class FileOutputter < IOOutputter
    attr_reader :trunc, :filename

    def initialize(_name, hash={})
      super(_name, nil, hash)

      @trunc = Log4rTools.decode_bool(hash, :trunc, false)
      _filename = (hash[:filename] or hash['filename'])
      @create = Log4rTools.decode_bool(hash, :create, true)

      if _filename.class != String
        raise TypeError, "Argument 'filename' must be a String", caller
      end

      # file validation
      if FileTest.exist?( _filename )
        if not FileTest.file?( _filename )
          raise StandardError, "'#{_filename}' is not a regular file", caller
        elsif not FileTest.writable?( _filename )
          raise StandardError, "'#{_filename}' is not writable!", caller
        end
      else # ensure directory is writable
        dir = File.dirname( _filename )
        if not FileTest.writable?( dir )
          raise StandardError, "'#{dir}' is not writable!"
        end
      end

      @filename = _filename
      if ( @create == true ) then
	@out = File.new(@filename, (@trunc ? "wb" : "ab")) 
	Logger.log_internal {
	  "FileOutputter '#{@name}' writing to #{@filename}"
	}
      else
	Logger.log_internal {
	  "FileOutputter '#{@name}' called with :create == false, #{@filename}"
	}
      end
    end

  end
  
end
