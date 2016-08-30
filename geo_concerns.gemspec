# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'geo_concerns/version'

Gem::Specification.new do |spec|
  spec.name          = 'geo_concerns'
  spec.version       = GeoConcerns::VERSION
  spec.authors       = [ 'James Griffin', 'Darren Hardy', 'John Huck', 'Eric James', 'Eliot Jordan' ]
  spec.email         = ['jrgriffiniii@gmail.com', 'drh@stanford.edu', 'jhuck@ualberta.ca', 'eric.james@yale.edu', 'eliotj@princeton.edu']
  spec.summary       = %q{Rails engine for Hydra Geo models. Built around Curation Concerns engine. }
  spec.description   = %q{Rails engine for Hydra Geo models. Built around Curation Concerns engine. }
  spec.homepage      = 'https://github.com/projecthydra-labs/geo_concerns'
  spec.license       = 'APACHE2'

  spec.files = `git ls-files | grep -v ^spec/fixtures`.split($\)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'curation_concerns', '1.4.0'
  spec.add_dependency 'leaflet-rails', '~> 0.7'
  spec.add_dependency 'simple_mapnik', '0.0.9'
  spec.add_dependency 'json-schema'

  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'devise', '4.1.1'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'engine_cart', '~> 0.10'
  spec.add_development_dependency 'solr_wrapper', '>= 0.13.1'
  spec.add_development_dependency 'fcrepo_wrapper', '~> 0.1'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'database_cleaner', '< 1.1.0'
  spec.add_development_dependency 'rubocop', '~> 0.39'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.4.1'
  spec.add_development_dependency 'factory_girl'
  spec.add_development_dependency 'capybara', '~> 2.7'
end
