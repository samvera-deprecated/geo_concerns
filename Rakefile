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

namespace :geo_concerns do
  desc 'Run style checker'
  RuboCop::RakeTask.new(:rubocop) do |task|
    task.requires << 'rubocop-rspec'
    task.fail_on_error = true
  end

  RSpec::Core::RakeTask.new(:rspec)

  desc 'Run test suite'
  task :spec do
    with_server 'test' do
      Rake::Task['geo_concerns:rspec'].invoke
    end
  end
end

desc 'Run test suite and style checker'
task spec: ['geo_concerns:rubocop', 'geo_concerns:spec']

desc 'Spin up Solr & Fedora and run the test suite'
task ci: ['engine_cart:generate'] do
  Rake::Task['spec'].invoke
end

task clean: 'engine_cart:clean'
task default: :ci
