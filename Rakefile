# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.
require 'bundler/setup'
require 'rubocop/rake_task'
require 'solr_wrapper'
require 'fcrepo_wrapper'
require 'coveralls/rake/task'

Coveralls::RakeTask.new

require File.expand_path('../config/application', __FILE__)
Dir.glob('tasks/*.rake').each { |r| import r }

# yard is not compatible with most recent rake release
# desc 'Generate the YARD documentation'
# YARD::Rake::YardocTask.new

desc 'Run style checker'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.requires << 'rubocop-rspec'
  task.fail_on_error = true
end

desc 'Run test suite with style checker'
task spec: :rubocop

task :ci do
  run_server 'test', solr_port: 8985, fcrepo_port: 8986 do
    Rake::Task['spec'].invoke
  end
end

namespace :server do
  desc 'Run Fedora and Solr for development environment'
  task :development do
    run_server 'development', solr_port: 8983, fcrepo_port: 8984 do
      IO.popen('rails server') do |io|
        io.each do |line|
          puts line
        end
      end
    end
  end

  desc 'Run Fedora and Solr for test environment'
  task :test do
    run_server 'test', solr_port: 8985, fcrepo_port: 8986 do
      sleep
    end
  end
end

def run_server(environment, solr_port: nil, fcrepo_port: nil)
  with_server(environment, solr_port: solr_port.to_s, fcrepo_port: fcrepo_port.to_s) do
    puts "\n#{environment.titlecase} servers running:\n"
    puts "    Fedora..: http://127.0.0.1:#{fcrepo_port}/rest/"
    puts "    Solr....: http://127.0.0.1:#{solr_port}/solr/hydra-#{environment}/"
    puts "\n^C to stop"
    begin
      yield
    rescue Interrupt
      puts "Shutting down..."
    end
  end
end

task default: :ci

Rails.application.load_tasks
