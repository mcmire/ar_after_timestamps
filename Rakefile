require 'rubygems'
require 'rake'

require File.dirname(__FILE__) + "/lib/mcmire/ar_after_timestamps"

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.version = Mcmire::ARAfterTimestamps::VERSION
    gem.name = "ar_after_timestamps"
    gem.summary = %Q{Rails gem that provides an AR callback right after timestamps are set and before the record is saved}
    gem.description = %Q{A little gem that gives you a way to add a callback to the ActiveRecord callback chain that will be executed right after the record's timestamp columns are set, but before the record is actually saved to the database. This is useful if you want to do something with the timestamps, such as defaulting another time column to created_at, or rolling back a timestamp by a certain amount.}
    gem.authors = ["Elliot Winkler"]
    gem.email = "elliot.winkler@gmail.com"
    gem.homepage = "http://github.com/mcmire/ar_after_timestamps"
    gem.add_dependency "activerecord", "< 3.0"
    gem.add_development_dependency "mcmire-protest", "~> 0.2.4"
    gem.add_development_dependency "mcmire-matchy", "~> 0.4.1"
    gem.add_development_dependency "mcmire-mocha", "~> 0.9.8"
    gem.add_development_dependency "mocha-protest-integration"
    #gem.add_development_dependency "yard", ">= 0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << File.dirname(__FILE__) << 'lib' << 'test'
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

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end