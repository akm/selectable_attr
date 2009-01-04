$KCODE='u' if RUBY_VERSION =~ /^1\.8/

require 'rspec/core'
require 'autotest/rspec2'

Dir['./spec/support/**/*.rb'].map {|f| require f}

$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
require File.join(File.dirname(__FILE__), '..', 'init')

# see http://d.hatena.ne.jp/nedate/20101004/1286183882
#
# quick monkey patch for rcov
#
# http://codefluency.com/post/1023734493/a-bandaid-for-rcov-on-ruby-1-9
#
if defined?(Rcov)
  class Rcov::CodeCoverageAnalyzer
    def update_script_lines__
      if '1.9'.respond_to?(:force_encoding)
        SCRIPT_LINES__.each do |k,v|
          v.each { |src| src.force_encoding('utf-8') }
        end
      end
      @script_lines__ = @script_lines__.merge(SCRIPT_LINES__)
    end
  end
end
