# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{selectable_attr}
  s.version = "0.3.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Takeshi Akima"]
  s.date = %q{2009-08-17}
  s.description = %q{selectable_attr generates extra methods dynamically for attribute which has options}
  s.email = %q{akima@gmail.com}
  s.extra_rdoc_files = [
    "README"
  ]
  s.files = [
    ".gitignore",
     "MIT-LICENSE",
     "README",
     "Rakefile",
     "VERSION.yml",
     "init.rb",
     "install.rb",
     "lib/selectable_attr.rb",
     "lib/selectable_attr/base.rb",
     "lib/selectable_attr/enum.rb",
     "lib/selectable_attr/version.rb",
     "selectable_attr.gemspec",
     "spec/selectable_attr_base_alias_spec.rb",
     "spec/selectable_attr_enum_spec.rb",
     "spec/spec_helper.rb",
     "tasks/selectable_attr_tasks.rake",
     "uninstall.rb"
  ]
  s.homepage = %q{http://github.com/akm/selectable_attr/}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{selectable_attr generates extra methods dynamically}
  s.test_files = [
    "spec/selectable_attr_base_alias_spec.rb",
     "spec/selectable_attr_enum_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
