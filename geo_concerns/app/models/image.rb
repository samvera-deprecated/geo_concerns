# Model for Image (Works) which bear basic geospatial metadata
class Image < ActiveFedora::Base
  include ::GeoConcerns::ImageBehavior
end
