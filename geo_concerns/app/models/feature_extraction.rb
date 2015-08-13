# A vector that has been transcribed from a raster (georectified map)
class FeatureExtraction < ActiveFedora::Base
  include ::GeoConcerns::FeatureExtractionBehavior
  validates_presence_of :title,  message: 'Your work must have a title.'
  validates_presence_of :georss_box,  message: 'Your work must have a bbox.'
end

