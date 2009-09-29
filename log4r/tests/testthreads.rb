# $Id$
# Test sent in by chetreddy bug #27184
# After threading synchronize blocks put in on MacPro Quad Woodcrest 2.6GHz
# running ruby 1.8.6, wall clock
# colby@gks tests $ time ruby testthreads.rb
#
# real	0m20.826s
# user	0m20.453s
# sys	0m0.344s
#

$: << File.join("..","src")

require 'rubygems'
require 'log4r'

NUM_THREADS=5000

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
