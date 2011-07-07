# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{mongoid_geo}
  s.version = File.read("VERSION")

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Kristian Mandrup}]
  s.date = %q{2011-05-31}
  s.description = %q{Makes it easy to use geo calculations with Mongoid}
  s.email = %q{kmandrup@gmail.com}
  s.extra_rdoc_files = [
    "README.textile"
  ]
  s.files = [
    ".document",
    ".rspec",
    "Changelog.textile",
    "Gemfile",
    "MIT-LICENSE",
    "README.textile",
    "Rakefile",
    "VERSION",
    "mongoid_geo.gemspec"]
  # s.files += Dir.glob("lib/**/*") 
  # s.files += Dir.glob("sandbox/**/*") 
  # s.files += Dir.glob("spec/**/*")

  s.homepage = %q{http://github.com/kristianmandrup/mongoid_geo}
  s.licenses = [%q{MIT}]
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.3}
  s.summary = %q{Mongoid geo extensions with support for native Mongo DB calculations}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mongoid>, [">= 2.1"])
      s.add_runtime_dependency(%q<bson>, [">= 1.3"])
      s.add_runtime_dependency(%q<bson_ext>, [">= 1.3"])
      s.add_runtime_dependency(%q<activesupport>, [">= 3"])
      s.add_development_dependency(%q<rspec>, [">= 2.4"])
      s.add_development_dependency(%q<bundler>, [">= 1"])
      s.add_development_dependency(%q<jeweler>, [">= 1.5"])
      s.add_development_dependency(%q<rdoc>, [">= 3.6"])
      s.add_development_dependency(%q<geo_calc>, ["~> 0.6.1"])
      s.add_development_dependency(%q<geo_vectors>, ["~> 0.5.1"])
    else
      s.add_dependency(%q<mongoid>, [">= 2.1"])
      s.add_dependency(%q<bson>, [">= 1.3"])
      s.add_dependency(%q<bson_ext>, [">= 1.3"])
      s.add_dependency(%q<activesupport>, [">= 3"])
      s.add_dependency(%q<rspec>, [">= 2.4"])
      s.add_dependency(%q<bundler>, [">= 1"])
      s.add_dependency(%q<jeweler>, [">= 1.5"])
      s.add_dependency(%q<rdoc>, [">= 3.6"])
      s.add_dependency(%q<geo_calc>, ["~> 0.6.1"])
      s.add_dependency(%q<geo_vectors>, ["~> 0.5.1"])
    end
  else
    s.add_dependency(%q<mongoid>, [">= 2.1"])
    s.add_dependency(%q<bson>, [">= 1.3"])
    s.add_dependency(%q<bson_ext>, [">= 1.3"])
    s.add_dependency(%q<activesupport>, [">= 3"])
    s.add_dependency(%q<rspec>, [">= 2.4"])
    s.add_dependency(%q<bundler>, [">= 1"])
    s.add_dependency(%q<jeweler>, [">= 1.5"])
    s.add_dependency(%q<rdoc>, [">= 3.6"])
    s.add_dependency(%q<geo_calc>, ["~> 0.6.1"])
    s.add_dependency(%q<geo_vectors>, ["~> 0.5.1"])
  end
end

