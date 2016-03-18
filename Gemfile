source 'https://rubygems.org'
ruby '2.2.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'rsolr', '~> 1.0.6'
gem 'devise'
gem 'devise-guests', '~> 0.3'

gem 'curation_concerns', '0.10.0'

gem "jquery-ui-rails"
gem "simple_form", '~> 3.1.0'
gem 'nokogiri'
gem 'equivalent-xml'
gem 'solr_wrapper', '~> 0.5.1'
gem 'fcrepo_wrapper', '~> 0.2'
gem 'coveralls', require: false

gem 'leaflet-rails'

group :development do
  # Yard is not compatible with most recent rake release.
  # https://github.com/lsegal/yard/pull/946
  # gem 'yard'
  gem 'xray-rails'
  gem 'web-console', '~> 2.0'
  gem 'spring'
end

group :development, :test do
  gem 'bundler', '~> 1.6'
  gem 'rake'
  gem 'rspec-its'
  gem 'rspec-rails', '>=3.4.2'
  gem 'rspec-html-matchers'
  gem 'rspec-activemodel-mocks', '~> 1.0'
  gem 'capybara'
  gem 'poltergeist', '>= 1.5.0'
  gem 'factory_girl'
  gem 'database_cleaner', '< 1.1.0'
  gem 'rubocop', '>=0.38.0', require: false
  gem 'rubocop-rspec', '>=1.4.0', require: false
  gem 'simplecov', '~> 0.9', require: false
  gem 'pry' unless ENV['CI']
  gem 'byebug' unless ENV['CI']
end
