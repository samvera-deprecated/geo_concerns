gem 'curation_concerns', '~> 0.14.0.pre4'
gem 'geo_concerns'

run 'bundle install'

generate 'curation_concerns:install'
generate 'geo_concerns:install'

rake 'db:migrate'
