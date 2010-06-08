
# :nodoc:
# Version:: $Id: rollingfileoutputter.rb,v 1.2 2009/09/29 18:13:13 colbygk Exp $

require "log4r/outputter/fileoutputter"
require "log4r/staticlogger"

require 'fileutils'

module Log4r

  # RollingFileOutputter - subclass of FileOutputter that rolls files on size
  # or time. So, given a filename of "error.log", the first log file will be "error000001.log".
  # When its check condition is exceeded, it'll create and log to "error000002.log", etc.
  #
  # Additional hash arguments are:
  #
  # [<tt>:maxsize</tt>]  Maximum size of the file in bytes.
  # [<tt>:maxtime</tt>]	 Maximum age of the file in seconds.
  # [<tt>:max_backups</tt>]  Maxium number of prior log files to maintain. If max_backups is a positive number, 
  #     then each time a roll happens, RollingFileOutputter will delete the oldest backup log files in excess
  #     of this number (if any).  So, if max_backups is 10, then a maximum of 11 files will be maintained (the current
  #     log, plus 10 backups). If max_backups is 0, no backups will be kept. If it is negative (the default),
  #     there will be no limit on the number of files created. Note that the sequence numbers will continue to escalate;
  #     old sequence numbers are not reused.
  # [<tt>:trunc</tt>]  If true, deletes ALL existing log files (based on :filename) upon initialization,
  #     and the sequence numbering will start over at 000001. Otherwise continues logging where it left off
  #     last time (i.e. either to the file with the highest sequence number, or a new file, as appropriate).
  class RollingFileOutputter < FileOutputter

    attr_reader :current_sequence_number, :maxsize, :maxtime, :start_time, :max_backups

    def initialize(_name, hash={})
      super( _name, hash.merge({:create => false}) )
      if hash.has_key?(:maxsize) || hash.has_key?('maxsize') 
        _maxsize = (hash[:maxsize] or hash['maxsize']).to_i
        if _maxsize.class != Fixnum
          raise TypeError, "Argument 'maxsize' must be an Fixnum", caller
        end
        if _maxsize == 0
          raise TypeError, "Argument 'maxsize' must be > 0", caller
        end
        @maxsize = _maxsize
      end
      if hash.has_key?(:maxtime) || hash.has_key?('maxtime') 
        _maxtime = (hash[:maxtime] or hash['maxtime']).to_i
        if _maxtime.class != Fixnum
          raise TypeError, "Argument 'maxtime' must be an Fixnum", caller
        end
        if _maxtime == 0
          raise TypeError, "Argument 'maxtime' must be > 0", caller
        end
        @maxtime = _maxtime
      end
      if hash.has_key?(:max_backups) || hash.has_key?('max_backups') 
        _max_backups = (hash[:max_backups] or hash['max_backups']).to_i
        if _max_backups.class != Fixnum
          raise TypeError, "Argument 'max_backups' must be an Fixnum", caller
        end
        @max_backups = _max_backups
      else
        @max_backups = -1
      end
      # @filename starts out as the file (including path) provided by the user, e.g. "\usr\logs\error.log".
      #   It will get assigned the current log file (including sequence number)   
      # @log_dir is the directory in which we'll log, e.g. "\usr\logs"
      # @file_extension is the file's extension (if any) including any period, e.g. ".log"
      # @core_file_name is the part of the log file's name, sans sequence digits or extension, e.g. "error"
      @log_dir = File.dirname(@filename)
      @file_extension = File.extname(@filename)   # Note: the File API doc comment states that this doesn't include the period, but its examples and behavior do include it. We'll depend on the latter.
      @core_file_name = File.basename(@filename, @file_extension)
      if (@trunc)
        purge_log_files(0)
      end
      @current_sequence_number = get_current_sequence_number()
      makeNewFilename
      # Now @filename points to a properly sequenced filename, which may or may not yet exist.
      open_log_file('a')
      
      # Note: it's possible we're already in excess of our time or size constraint for the current file;
      # no worries -- if a new file needs to be started, it'll happen during the write() call. 
    end

    #######
    private
    #######

	  # Delete all but the latest number_to_keep log files.
    def purge_log_files(number_to_keep)
      Dir.chdir(@log_dir) do
        # Make a list of the log files to delete. Start with all of the matching log files...
        glob = "#{@core_file_name}[0-9][0-9][0-9][0-9][0-9][0-9]#{@file_extension}"
        files = Dir.glob(glob)
        
        # ... if there are fewer than our threshold, just return... 
        if (files.size() <= number_to_keep )
          # Logger.log_internal {"No log files need purging."}
          return
        end
        # ...then remove those that we want to keep (i.e. the most recent #{number_to_keep} files). 
        files.sort!().slice!(-number_to_keep, number_to_keep)
        
        # Delete the files. We use force (rm_f), so in case any files can't be deleted (e.g. someone's got one
        # open in an editor), we'll swallow the error and keep going.
        FileUtils.rm_f(files)
        Logger.log_internal { "Purged #{files.length} log files: #{files}" }
      end
    end

	# Get the highest existing log file sequence number, or 1 if there are no existing log files.
    def get_current_sequence_number()
      max_seq_no = 0
      Dir.foreach(@log_dir) do |child|
        if child =~ /^#{@core_file_name}(\d+)#{@file_extension}$/
          seq_no = $1.to_i
          if (seq_no > max_seq_no)
            max_seq_no = seq_no
          end
        end
      end
      return [max_seq_no, 1].max
    end

    # perform the write
    def write(data) 
      # we have to keep track of the file size ourselves - File.size doesn't
      # seem to report the correct size when the size changes rapidly
      @datasize += data.size + 1 # the 1 is for newline
      roll if requiresRoll
      super
    end

    # Constructs a new filename from the @current_sequence_number, @core_file_name, and @file_extension,
    # and assigns it to @filename
    def makeNewFilename
      # note use of hard coded 6 digit sequence width - is this enough files?
      padded_seq_no = "0" * (6 - @current_sequence_number.to_s.length) + @current_sequence_number.to_s
      newbase = "#{@core_file_name}#{padded_seq_no}#{@file_extension}"
      @filename = File.join(@log_dir, newbase)
    end 

    # Open @filename with the given mode:
    #    'a' - appends to the end of the file if it exists; otherwise creates it.
    #    'w' -  truncates the file to zero length if it exists, otherwise creates it.
    # Re-initializes @datasize and @startime appropriately.
    def open_log_file(mode)
      # It appears that if a file has been recently deleted then recreated, calls like
      # File.ctime can return the erstwhile creation time. File.size? can similarly return
      # old information. So instead of simply doing ctime and size checks after File.new, we 
      # do slightly more complicated checks beforehand:
      if (mode == 'w' || !File.exists?(@filename))
        @start_time = Time.now()
        @datasize = 0
      else
        @start_time = File.ctime(@filename)
        @datasize = File.size?(@filename) || 0 # File.size? returns nil even if the file exists but is empty; we convert it to 0.
      end
      @out = File.new(@filename, mode)
      Logger.log_internal {"File #{@filename} opened with mode #{mode}"}
    end

    # does the file require a roll?
    def requiresRoll
      if !@maxsize.nil? && @datasize > @maxsize
        Logger.log_internal { "Rolling because #{@filename} (#{@datasize} bytes) has exceded the maxsize limit (#{@maxsize} bytes)." }
        return true
      end
      if !@maxtime.nil? && (Time.now - @start_time) > @maxtime
        Logger.log_internal { "Rolling because #{@filename} (created: #{@start_time}) has exceded the maxtime age (#{@maxtime} seconds)." }
        return true
      end
      false
    end 

    # roll the file
    def roll
      begin
        # If @baseFilename == @filename, then this method is about to
        # try to close out a file that is not actually opened because
        # fileoutputter has been called with the parameter roll=true        
        # TODO: Is this check valid any more? I suspect not. Am commenting out...:
        #if ( @baseFilename != @filename ) then
          @out.close
        #end
      rescue 
        Logger.log_internal {
          "RollingFileOutputter '#{@name}' could not close #{@filename}"
        }
      end

      # Prepare the next file. (Note: if max_backups is zero, we can skip this; we'll
      # just overwrite the existing log file) 
      if (@max_backups != 0)
        @current_sequence_number += 1
        makeNewFilename
      end
      
      open_log_file('w')
      
      # purge any excess log files (unless max_backups is negative, which means don't purge).
      if (@max_backups >= 0) 
        purge_log_files(@max_backups + 1)
      end

    end 

  end

end

# this can be found in examples/fileroll.rb as well
if __FILE__ == $0
  require 'log4r'
  include Log4r


  timeLog = Logger.new 'WbExplorer'
  timeLog.outputters = RollingFileOutputter.new("WbExplorer", { "filename" => "TestTime.log", "maxtime" => 10, "trunc" => true })
  timeLog.level = DEBUG

  100.times { |t|
    timeLog.info "blah #{t}"
    sleep(1.0)
  }

  sizeLog = Logger.new 'WbExplorer'
  sizeLog.outputters = RollingFileOutputter.new("WbExplorer", { "filename" => "TestSize.log", "maxsize" => 16000, "trunc" => true })
  sizeLog.level = DEBUG

  10000.times { |t|
    sizeLog.info "blah #{t}"
  }

end
