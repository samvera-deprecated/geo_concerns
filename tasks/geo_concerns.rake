require 'solr_wrapper'
require 'fcrepo_wrapper'

namespace :geo_concerns do
  desc "Run development servers for Geo Concerns"
  task :dev_servers do
    with_server 'development' do
      begin
        sleep
      rescue Interrupt
        puts "Shutting down..."
      end
    end
  end
  desc "Run test servers for Geo Concerns"
  task :test_servers do
    with_server 'test' do
      begin
        sleep
      rescue Interrupt
        puts "Shutting down..."
      end
    end
  end
end
