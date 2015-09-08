# A vector that has been transcribed from a raster (georectified map)
class FeatureExtraction < ActiveFedora::Base
  include ::GeoConcerns::FeatureExtractionBehavior
end
