# $Id$
# Test sent in by chetreddy bug #27184
# 
# Note: this test won't always catch a threading problem, as it
# relies on a brute force approach.  NUM_THREADS can be increased
# to stress the system longer and therefore increasing the chance
# of exposing a threading issue, however, it is not a definitive
# test.
#

$: << File.join("..","src")

require 'rubygems'
require 'log4r'

NUM_THREADS=2000

cnt = 0

Log4r::Logger.new "Hello -1"

begin
  (0..NUM_THREADS).map do |i|
    cnt = i
    Thread.new do
      Thread.current[:logger] = Log4r::Logger.new "Hello #{i}"
    end
  end.each { |thr| thr.join }
rescue
  puts "FAIL: #{$!} on iteration #{cnt}"
end
