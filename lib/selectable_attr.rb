# -*- coding: utf-8 -*-
require 'logger'

module SelectableAttr
  autoload :VERSION, 'selectable_attr/version'
  autoload :Enum, 'selectable_attr/enum'
  autoload :Base, 'selectable_attr/base'

  class << self
    def logger
      @logger ||= Logger.new(STDERR)
    end
    def logger=(value)
      @logger = value
    end
  end
end
