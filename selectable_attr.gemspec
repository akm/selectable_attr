require File.join(File.dirname(__FILE__), 'lib', 'selectable_attr', 'version')

Gem::Specification.new do |s|
  s.name     = "selectable_attr"
  s.version  = SelectableAttr::VERSION
  s.date     = Time.now.strftime("%Y/%m/%d %H:%M:%S")
  s.summary  = "selectable_attr generates extra methods dynamically"
  s.email    = "akima@gmail.com"
  s.authors  = ["Takeshi Akima"]
  s.homepage = "http://github.com/akm/selectable_attr/"
  s.has_rdoc = false

  s.files = [
    "Rakefile", "init.rb", "install.rb", "uninstall.rb", 
    "lib/selectable_attr/base.rb",
    "lib/selectable_attr/enum.rb",
    "lib/selectable_attr/version.rb",
    "lib/selectable_attr.rb",
    "spec/selectable_attr_base_alias_spec.rb",
    "spec/selectable_attr_enum_spec.rb",
    "spec/spec_helper.rb",
    "tasks/selectable_attr_tasks.rake"]
end
