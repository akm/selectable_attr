$KCODE='u'
require 'test/unit'

$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
require File.join(File.dirname(__FILE__), '..', 'init')

class Test::Unit::TestCase
  
  def assert_hash(expected, actual)
    keys = (expected.keys + actual.keys).uniq
    keys.each do |key|
      assert_equal expected[key], actual[key], "unmatch value for #{key.inspect}"
    end
  end
end
