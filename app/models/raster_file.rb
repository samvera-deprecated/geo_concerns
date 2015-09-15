# Model for Raster geospatial data files which bear basic geospatial metadata and an authoritative CRS
class RasterFile < ActiveFedora::Base
  include ::GeoConcerns::RasterFileBehavior
end
