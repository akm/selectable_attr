# require File.join(File.dirname(__FILE__), 'lib', 'selectable_attr', 'version')

Gem::Specification.new do |s|
  s.name     = "selectable_attr"
  s.version  = '0.0.3'
  s.date     = '2009/01/26' # Time.now.strftime("%Y/%m/%d %H:%M:%S")
  s.summary  = "selectable_attr generates extra methods dynamically"
  s.description  = "selectable_attr generates extra methods dynamically for attribute which has options"
  s.email    = "akima@gmail.com"
  s.homepage = "http://github.com/akm/selectable_attr/"
  s.has_rdoc = false
  s.authors  = ["Takeshi Akima"]

  s.files = [
    "MIT-LICENSE", "README", 
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
