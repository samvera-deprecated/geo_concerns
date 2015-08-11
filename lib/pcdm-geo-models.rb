require 'hydra/works'
require 'curation_concerns'
require 'pcdm-geo-models/behaviors'

# PCDM based geospatial models for Hydra
module GeoHydra
  # Models for works
  module Works
    
    # Base class for all GeoHydra objects
    class Base < ::Hydra::Works::GenericWork::Base
      # property :bbox, BoundingBox
      # ...
      include GeoHydra::Works::Behaviors::Base
    end
  
    # Vector work like shapefiles with attribute tables
    class Vector < Base
      # property :projection, String
      # property :attributeTable, Array
      # ...
      include GeoHydra::Works::Behaviors::Vector
    end
  
    # Base class for Images that are georeferenced with a bbox
    class Image < Base # maybe mix-in with a generic Image class
      # property :height, Integer
      # property :width, Integer
      # ...
      include GeoHydra::Works::Behaviors::Image
    end
    
    # A georeferenced map that been warped or Raster work like GeoTIFF
    class Raster < Image
      # property :projection, String
      # property :resolution, Float
      # associated_with :image (derived from, optional)
      # ...
      include GeoHydra::Works::Behaviors::Raster
    end
  
    # A vector that has been transcribed from a raster (georectified map)
    class FeatureExtraction < Vector
      # associated_with :raster (derived from, required)
      # property :transcribedBy, String
      # ...
      include GeoHydra::Works::Behaviors::FeatureExtraction
    end
  end
end