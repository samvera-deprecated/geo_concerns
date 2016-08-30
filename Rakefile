begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end
require 'engine_cart/rake_task'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'active_fedora/rake_support'

Dir.glob('tasks/*.rake').each { |r| import r }

Bundler::GemHelper.install_tasks

desc 'Run test suite and style checker'
task spec: ['geo_concerns:spec']

desc 'Spin up Solr & Fedora and run the test suite'
task ci: ['geo_concerns:rubocop', 'engine_cart:generate'] do
  Rake::Task['spec'].invoke
end

task clean: 'engine_cart:clean'
task default: :ci
