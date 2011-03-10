require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'
require 'jeweler'

Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "tworgy-spaced-repetition"
  gem.summary = %Q{Spaced repetition algorithms and mixins}
  gem.description = %Q{A collection of spaced-reptetition algorithms and mixins e.g. SuperMemo}
  gem.email = "code@tworgy.com"
  gem.homepage = "http://github.com/matholroyd/tworgy-spaced-repetition"
  gem.authors = ["Mat Holroyd"]
  gem.add_development_dependency "rspec", ">= 1.2.9"
  gem.files = %w(LICENSE README.rdoc Rakefile) + Dir.glob("{lib,spec}/**/*")
  gem.license = "MIT"
  gem.add_development_dependency 'rspec', "~> 2.3.0"
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "tworgy-spaced-repetition #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
