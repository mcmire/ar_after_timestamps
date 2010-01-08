require 'rubygems'
require 'rake'

require File.dirname(__FILE__) + "/lib/mcmire/after_timestamps/version.rb"

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.version = Mcmire::AfterTimestamps::VERSION
    gem.name = "after_timestamps"
    gem.summary = %Q{Rails plugin that provides an AR callback right after timestamps are set and before the record is saved}
    gem.description = %Q{Plugin for Ruby on Rails that gives you a way to add a callback to the ActiveRecord callback chain that will be executed right after the record's timestamp columns are set, but before the record is actually saved to the database. This is useful if you want to modify the timestamp values.}
    gem.authors = ["Elliot Winkler"]
    gem.email = "elliot.winkler@gmail.com"
    gem.homepage = "http://github.com/mcmire/after_timestamps"
    gem.add_dependency "activerecord", ">= 1.2.6"
    gem.add_development_dependency "mcmire-context", ">= 0.5.6"
    gem.add_development_dependency "mcmire-matchy", ">= 0.4.1"
    gem.add_development_dependency "rr", ">= 0.10.5"
    gem.add_development_dependency "rr-matchy", ">= 0.1.0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "after_timestamps #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end