# Model for geospatial Vector feature files which bear basic geospatial metadata and an authoritative CRS
class VectorFile < ActiveFedora::Base
  include ::GeoConcerns::VectorFileBehavior
end
