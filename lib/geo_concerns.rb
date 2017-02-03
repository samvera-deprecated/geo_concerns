require 'curation_concerns'
require "geo_concerns/engine"
require 'leaflet-rails'

module GeoConcerns
  def self.root
    Pathname.new(File.expand_path('../../', __FILE__))
  end
end
