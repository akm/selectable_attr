# -*- coding: utf-8 -*-
module SelectableAttr
  VERSION = '0.0.2' # バージョンアップする前に変更します
  
  autoload :Enum, 'selectable_attr/enum'
  autoload :Base, 'selectable_attr/base'
  autoload :Helpers, 'selectable_attr/helpers'
  autoload :DbLoadable, 'selectable_attr/db_loadable'
end
