# Model for geospatial vector feature extractions derived from a raster data set
class FeatureExtraction < ActiveFedora::Base
  include ::GeoConcerns::FeatureExtractionBehavior
end
