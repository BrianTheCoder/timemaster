require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "timemaster"
    gem.summary = %Q{A way to easily store time based data scalably in riak}
    gem.description = %Q{Creates buckets for a given resolution and will create all the appropriate links}
    gem.email = "wbsmith83@gmail.com"
    gem.homepage = "http://github.com/BrianTheCoder/chronos"
    gem.authors = ["brianthecoder"]
    gem.files.include %w(lib/chronos.rb lib/chronos/document.rb lib/chronos/extensions.rb lib/chronos/helpers.rb lib/chronos/resolution.rb lib/chronos/version.rb)
    gem.add_development_dependency "yard"
    gem.add_dependency "riak-client"
    gem.add_dependency "activesupport"
    gem.add_dependency "hashie"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
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

begin
  require 'reek/rake_task'
  Reek::RakeTask.new do |t|
    t.fail_on_error = true
    t.verbose = false
    t.source_files = 'lib/**/*.rb'
  end
rescue LoadError
  task :reek do
    abort "Reek is not available. In order to run reek, you must: sudo gem install reek"
  end
end

task :default => :test

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end