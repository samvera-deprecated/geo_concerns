gem 'curation_concerns', '1.0.0.beta7'
gem 'geo_concerns', '0.0.6'

run 'bundle install'

generate 'curation_concerns:install', '-f'
generate 'geo_concerns:install', '-f'

rake 'db:migrate'
