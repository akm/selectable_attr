require 'rake'
require File.join(File.dirname(__FILE__), 'lib', 'selectable_attr', 'version')

Gem::Specification.new do |spec|
  spec.name     = "selectable_attr"
  spec.version  = SelectableAttr::VERSION
  spec.date     = Time.now.strftime("%Y/%m/%d %H:%M:%S")
  spec.summary  = "selectable_attr generates extra methods dynamically"
  spec.email    = "akima@gmail.com"
  spec.authors  = ["Takeshi Akima"]
  spec.homepage = "http://github.com/akm/selectable_attr/"
  spec.has_rdoc = false

  spec.add_dependency("activerecord", ">= 2.1.0")
  spec.add_dependency("selectable_attr", SelectableAttr::VERSION)

  spec.files         = FileList['Rakefile', 'bin/*', '*.rb', '{lib,test}/**/*.{rb}', 'tasks/**/*.{rake}'].to_a
  spec.require_path  = "lib"
  spec.requirements  = ["none"]
  # spec.autorequire = 'selectable_attr_rails' # autorequire is deprecated
end
