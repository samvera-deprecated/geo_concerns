# Model for Image (Files) which bear basic geospatial metadata and an authoritative CRS
class ImageFile < ActiveFedora::Base
  include ::GeoConcerns::ImageFileBehavior
end
