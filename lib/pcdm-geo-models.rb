require 'hydra/works'
require 'curation_concerns'

# PCDM based geospatial models for Hydra
module GeoHydra
  # Models for works
  module Works
    
    # Base class for all GeoHydra objects
    class GeoWork < ::Hydra::Works::GenericWork::Base
      # property :bbox, BoundingBox
      # ...
    end
  
    # Vector work like shapefiles with attribute tables
    class Vector < GeoWork
      # property :projection, String
      # property :attributeTable, Array
      # ...
    end
  
    # Base class for Images that are georeferenced with a bbox
    class Image < GeoWork # maybe mix-in with a generic Image class
      # property :height, Integer
      # property :width, Integer
      # ...
    end
    
    # A georeferenced map that been warped or Raster work like GeoTIFF
    class Raster < Image
      # property :projection, String
      # property :resolution, Float
      # ...
    end
  
    # A vector that has been transcribed from a raster (georectified map)
    class FeatureExtraction < Vector
      # associated_with :raster
      # property :transcribedBy, String
      # ...
    end
  end
end