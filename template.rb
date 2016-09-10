gem 'curation_concerns', '1.5.0'
gem 'geo_concerns', '0.0.8'

run 'bundle install'

generate 'curation_concerns:install', '-f'
generate 'geo_concerns:install', '-f'

rake 'db:migrate'
