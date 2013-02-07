# encoding: utf-8

require 'rubygems'

begin
  require 'bundler'
rescue LoadError => e
  warn e.message
  warn "Run `gem install bundler` to install Bundler."
  exit -1
end

begin
  Bundler.setup(:development)
rescue Bundler::BundlerError => e
  warn e.message
  warn "Run `bundle install` to install missing gems."
  exit e.status_code
end

require 'rake'

require 'rdoc/task'
RDoc::Task.new do |rdoc|
  rdoc.title = "search_path"
end
task :doc => :rdoc

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

task :test    => :spec
task :default => :spec

#require 'rubygems/tasks'
#Gem::Tasks.new

#Bundler::GemHelper.install_tasks
#
## TODO 09.12.12/17:11/tbaustert remove
require 'tb_gem_release/gem_tasks'