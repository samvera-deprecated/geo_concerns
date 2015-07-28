require 'hydra/works'
require 'curation_concerns'

# PCDM based geospatial models for Hydra
module GeoHydra
  # Models for works
  module Works
    
    # Base class for all GeoHydra objects
    class GeoWork < ::Hydra::Works::GenericWork::Base
      # property ???
    end
  
    # Vector work like shapefiles
    class Vector < GeoWork
      # property ???
    end
  
    # Raster work like GeoTIFF
    class Raster < GeoWork # maybe mix-in with a generic Image class
      # property ???
    end
  
    # A raster that is semantically a scanned map
    class ScannedMap < Raster
      # property ???
    end
  
    # A scanned map with a bounding box
    class GeoreferencedMap < ScannedMap
      # property :bbox
    end

    # A georeferenced map that been warped
    class GeorectifiedMap < GeoreferencedMap
      # property ???
    end
  
    # A vector that has been transcribed from a georectified map
    class FeatureExtraction < Vector
      # associated_with :georectifiedMap
    end
  end
end