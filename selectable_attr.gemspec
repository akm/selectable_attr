require 'rake'
require File.join(File.dirname(__FILE__), 'lib', 'selectable_attr', 'version')

Gem::Specification.new do |spec|
  spec.name = "selectable_attr"
  spec.version = SelectableAttr::VERSION
  spec.platform = "ruby"
  spec.summary = "selectable_attr generates extra methods dynamically"
  spec.author = "Takeshi Akima"
  spec.email = "akima@gmail.com"
  spec.homepage = "http://d.hatena.ne.jp/akm"
  spec.rubyforge_project = "rubybizcommons"
  spec.has_rdoc = false

  # spec.add_dependency("activesupport", ">= 2.1.0")

  spec.files = FileList['Rakefile', 'bin/*', '*.rb', '{lib,test}/**/*.{rb}', 'tasks/**/*.{rake}'].to_a
  spec.require_path = "lib"
  spec.requirements = ["none"]
  # spec.autorequire = 'selectable_attr' # autorequire is deprecated
  
  # bin_files = FileList['bin/*'].to_a.map{|file| file.gsub(/^bin\//, '')}
  # spec.executables = bin_files
  
  # spec.default_executable = 'some_executable.sh'
end
