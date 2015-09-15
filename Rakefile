# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
Rails.application.load_tasks

require 'bundler/gem_tasks'
require 'bundler/setup'
require 'rspec/core/rake_task'
require 'jettywrapper'
require 'rubocop/rake_task'

Dir.glob('tasks/*.rake').each { |r| import r }

# This makes it possible to run curation_concerns:jetty:config from here.
import 'lib/tasks/geo_concerns_tasks.rake'

Jettywrapper.hydra_jetty_version = 'v8.3.1'

desc 'Generate the YARD documentation'
YARD::Rake::YardocTask.new

desc 'Run style checker'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.requires << 'rubocop-rspec'
  task.fail_on_error = true
end

desc 'Run test suite and style checker'
task spec: :rubocop do
  RSpec::Core::RakeTask.new(:spec)
end

# Could not find jetty:config within release 2.0.3
task ci: ['jetty:clean', 'jetty:config', 'db:test:prepare'] do
  puts 'running continuous integration'
  jetty_params = Jettywrapper.load_config
  jetty_params[:startup_wait] = 90

  error = Jettywrapper.wrap(jetty_params) do
    Rake::Task['spec'].invoke
  end
  fail "test failures: #{error}" if error
end

task default: :ci
