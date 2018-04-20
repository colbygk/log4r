require 'test_helper'
require 'log4r/outputter/syslogoutputter'

class TestSyslogOutputter < TestCase
  def test_concurrency
    threads = []
    (1..20).each do
      threads << Thread.new do
        #Create log and add syslog outputter
        id = Thread.current.__id__
        id = id.to_s()
        log = Log4r::Logger.new(id)
        log.add(Log4r::SyslogOutputter.new(id))
    
        (1..200).each do
          log.debug "debugging"
          log.info "a piece of info"
          log.warn "Danger, Will Robinson, danger!"
          log.error "I dropped my Wookie! :("
          log.fatal "kaboom!"
          Thread.pass()
        end
      end
    end

    threads.each do |thread|
      assert_nothing_raised(Exception) do
        thread.join()
      end
    end
  end
end