require "bundler"
Bundler.setup
Bundler::GemHelper.install_tasks

require "rake"
require "yaml"

require "rake/rdoctask"
require "rspec/core/rake_task"
require "rspec/core/version"
# require "cucumber/rake/task"

desc 'Default: run unit tests.'
task :default => :spec
# task :default => [:spec, :cucumber]

desc "Run all examples"
RSpec::Core::RakeTask.new(:spec)

namespace :spec do
  desc "Run all examples using rcov"
  RSpec::Core::RakeTask.new(:rcov) do |t|
    t.rcov = true
    t.rcov_opts =  %[--exclude "gems/*"]
    # t.rcov_opts << %[--sort]
  end
end

task :cleanup_rcov_files do
  rm_rf 'coverage.data'
end

desc 'Generate documentation for the selectable_attr plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'SelectableAttr'
  rdoc.options << '--line-numbers' << '--inline-source' << '-c UTF-8'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
