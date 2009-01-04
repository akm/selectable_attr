$KCODE='u' if RUBY_VERSION =~ /^1\.8/

require 'rspec/core'
require 'autotest/rspec2'

Dir['./spec/support/**/*.rb'].map {|f| require f}

$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
require File.join(File.dirname(__FILE__), '..', 'init')
