# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{timemaster}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["brianthecoder"]
  s.date = %q{2010-06-30}
  s.description = %q{Creates buckets for a given resolution and will create all the appropriate links}
  s.email = %q{wbsmith83@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc",
     "TODO"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "TODO",
     "VERSION",
     "examples/request.rb",
     "lib/timemaster.rb",
     "lib/timemaster/document.rb",
     "lib/timemaster/extensions.rb",
     "lib/timemaster/helpers.rb",
     "lib/timemaster/resolution.rb",
     "lib/timemaster/version.rb",
     "test/chronos_test.rb",
     "test/teststrap.rb"
  ]
  s.homepage = %q{http://github.com/BrianTheCoder/chronos}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A way to easily store time based data scalably in riak}
  s.test_files = [
    "test/chronos_test.rb",
     "test/teststrap.rb",
     "examples/request.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<yard>, [">= 0"])
      s.add_runtime_dependency(%q<riak-client>, [">= 0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
      s.add_runtime_dependency(%q<hashie>, [">= 0"])
    else
      s.add_dependency(%q<yard>, [">= 0"])
      s.add_dependency(%q<riak-client>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<hashie>, [">= 0"])
    end
  else
    s.add_dependency(%q<yard>, [">= 0"])
    s.add_dependency(%q<riak-client>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<hashie>, [">= 0"])
  end
end

