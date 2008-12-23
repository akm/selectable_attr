require 'test/unit'

require 'rubygems'
require 'activerecord'
require 'activesupport'


$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
require 'selectable_attr'

# require File.expand_path(File.join(File.dirname(__FILE__), '../../../../config/environment.rb'))

class Test::Unit::TestCase
  
  def assert_hash(expected, actual)
    keys = (expected.keys + actual.keys).uniq
    keys.each do |key|
      assert_equal expected[key], actual[key], "unmatch value for #{key.inspect}"
    end
  end
end
