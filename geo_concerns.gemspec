$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "geo_concerns/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name          = "geo_concerns"
  s.version       = GeoConcerns::VERSION
  s.authors       = [ "James Griffin", "Darren Hardy", "John Huck", "Eric James", "Eliot Jordan" ]
  s.email         = [""]
  s.summary       = %q{Rails application for developing Hydra Geo models. Built around Curation Concerns engine. }
  s.description   = %q{Rails application for developing Hydra Geo models. Built around Curation Concerns engine. }
  s.homepage      = ""
  s.license       = "APACHE2"


  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.2.6"
  s.add_dependency "curation_concerns", '~> 0.14.0.pre1'
  s.add_dependency 'leaflet-rails'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "engine_cart"
  s.add_development_dependency "solr_wrapper"
  s.add_development_dependency "fcrepo_wrapper", '~> 0.1'
  s.add_development_dependency "pry-byebug"
  s.add_development_dependency "database_cleaner", "< 1.1.0"
  s.add_development_dependency "rubocop"
  s.add_development_dependency "rubocop-rspec"
  s.add_development_dependency "factory_girl"
  s.add_development_dependency "capybara"
end
