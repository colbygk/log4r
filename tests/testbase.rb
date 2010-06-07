$: << File.join("..","lib")
require "test/unit"
require "log4r"
include Log4r

class TestBase < Test::Unit::TestCase
  # check that LNAMES loads properly (it uses an eval to load)
  def test_default_levels
    Logger.root              # doing this loads the default levels
    assert_equal(ALL,0)
    assert_equal(DEBUG,1)
    assert_equal(INFO,2)
    assert_equal(WARN,3)
    assert_equal(ERROR,4)
    assert_equal(FATAL,5)
    assert_equal(OFF,6)
    assert_equal(LEVELS, 7)
    assert_equal(LNAMES.size, 7)
  end
  # check bad input and bounds for validate_level
  def test_validate_level
    7.times{|i| assert_nothing_raised {Log4rTools.validate_level(i)} }
    assert_raises(ArgumentError) {Log4rTools.validate_level(-1)}
    assert_raises(ArgumentError) {Log4rTools.validate_level(LEVELS)}
    assert_raises(ArgumentError) {Log4rTools.validate_level(String)}
    assert_raises(ArgumentError) {Log4rTools.validate_level("bogus")}
  end
  # decode_bool turns a string 'true' into true and so on
  def test_decode_bool
    # when the key is a symbol :data
    assert(Log4rTools.decode_bool({:data=> 'true'}   ,:data,false) == true)
    assert(Log4rTools.decode_bool({:data=> true}     ,:data,false) == true)
    assert(Log4rTools.decode_bool({:data=> 'false'}  ,:data,true) == false)
    assert(Log4rTools.decode_bool({:data=> false}    ,:data,true) == false)
    assert(Log4rTools.decode_bool({:data=> nil}      ,:data,true) == true)
    assert(Log4rTools.decode_bool({:data=> nil}      ,:data,false) == false)
    assert(Log4rTools.decode_bool({:data=> String}   ,:data,true) == true)
    assert(Log4rTools.decode_bool({:data=> String}   ,:data,false) == false)
    # now the key is a string 'data'
    assert(Log4rTools.decode_bool({'data'=> 'true'}  ,:data,false) == true)
    assert(Log4rTools.decode_bool({'data'=> true}    ,:data,false) == true)
    assert(Log4rTools.decode_bool({'data'=> 'false'} ,:data,true) == false)
    assert(Log4rTools.decode_bool({'data'=> false}   ,:data,true) == false)
    assert(Log4rTools.decode_bool({'data'=> nil}     ,:data,true) == true)
    assert(Log4rTools.decode_bool({'data'=> nil}     ,:data,false) == false)
    assert(Log4rTools.decode_bool({'data'=> String}  ,:data,true) == true)
    assert(Log4rTools.decode_bool({'data'=> String}  ,:data,false) == false)
  end
end
