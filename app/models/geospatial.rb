# Model for Image (Works) which bear basic geospatial metadata
class Geospatial < ActiveFedora::Base
  include ::GeoConcerns::GeospatialBehavior
end
