begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end
require 'engine_cart/rake_task'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'active_fedora/rake_support'
require 'solr_wrapper/rake_task'

Dir.glob('tasks/*.rake').each { |r| import r }

Bundler::GemHelper.install_tasks

desc 'Run test suite'
task spec: ['geo_concerns:rspec']

desc 'Spin up Solr & Fedora and run the test suite'
task ci: ['geo_concerns:rubocop', 'engine_cart:generate'] do
  Rake::Task['geo_concerns:spec'].invoke
end

task clean: 'engine_cart:clean'
task default: :ci
