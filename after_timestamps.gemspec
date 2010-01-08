# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{after_timestamps}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Elliot Winkler"]
  s.date = %q{2010-01-07}
  s.description = %q{Plugin for Ruby on Rails that gives you a way to add a callback to the ActiveRecord callback chain that will be executed right after the record's timestamp columns are set, but before the record is actually saved to the database. This is useful if you want to do something with the timestamps, such as defaulting another time column to created_at, or rolling back a timestamp by a certain amount.}
  s.email = %q{elliot.winkler@gmail.com}
  s.extra_rdoc_files = [
    "README.md"
  ]
  s.files = [
    "README.md",
     "Rakefile",
     "lib/mcmire/after_timestamps.rb",
     "lib/mcmire/after_timestamps/version.rb",
     "rails/init.rb",
     "test/after_timestamps_test.rb",
     "test/helper.rb"
  ]
  s.homepage = %q{http://github.com/mcmire/after_timestamps}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Rails plugin that provides an AR callback right after timestamps are set and before the record is saved}
  s.test_files = [
    "test/after_timestamps_test.rb",
     "test/helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 1.2.6"])
      s.add_development_dependency(%q<mcmire-context>, [">= 0.5.6"])
      s.add_development_dependency(%q<mcmire-matchy>, [">= 0.4.1"])
      s.add_development_dependency(%q<rr>, [">= 0.10.5"])
      s.add_development_dependency(%q<rr-matchy>, [">= 0.1.0"])
    else
      s.add_dependency(%q<activerecord>, [">= 1.2.6"])
      s.add_dependency(%q<mcmire-context>, [">= 0.5.6"])
      s.add_dependency(%q<mcmire-matchy>, [">= 0.4.1"])
      s.add_dependency(%q<rr>, [">= 0.10.5"])
      s.add_dependency(%q<rr-matchy>, [">= 0.1.0"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 1.2.6"])
    s.add_dependency(%q<mcmire-context>, [">= 0.5.6"])
    s.add_dependency(%q<mcmire-matchy>, [">= 0.4.1"])
    s.add_dependency(%q<rr>, [">= 0.10.5"])
    s.add_dependency(%q<rr-matchy>, [">= 0.1.0"])
  end
end

