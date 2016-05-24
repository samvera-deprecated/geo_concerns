gem 'curation_concerns', '1.0.0.beta3'
gem 'geo_concerns', '0.0.4'

run 'bundle install'

generate 'curation_concerns:install'
generate 'geo_concerns:install'

rake 'db:migrate'
