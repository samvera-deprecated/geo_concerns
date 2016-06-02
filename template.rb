gem 'curation_concerns', '1.0.0.beta3'
gem 'geo_concerns', '0.0.5'

run 'bundle install'

generate 'curation_concerns:install', '-f'
generate 'geo_concerns:install', '-f'

rake 'db:migrate'
