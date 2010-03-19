# $Id$
# Test guts sent in by chetreddy bug #27184
# 
# Note: this test won't always catch a threading problem, as it
# relies on a brute force approach.  NUM_THREADS can be increased
# to stress the system longer and therefore increasing the chance
# of exposing a threading issue, however, it is not a definitive
# test.
#

class TestThreads < TestCase
  def test_threads
    NUM_THREADS=2000
    assert_no_exception
    {
      (0..NUM_THREADS).map do |i|
      Thread.new do
	Thread.current[:logger] = Log4r::Logger.new "Hello #{i}"
      end
      end.each { |thr| thr.join }
    }
  end
end
