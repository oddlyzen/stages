require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'


require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/test_*.rb'
  test.verbose = true
end

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "stages"
  gem.homepage = "https://github.com/iGoDigital-LLC/stages"
  gem.summary = "pipeline builder"
  gem.description = "pipeline builder"
  gem.email = "support@igodigital.com"
  gem.authors = ["The Justice Eight"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new
