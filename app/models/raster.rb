# Model for (Works of) Raster geospatial data sets which bear basic geospatial metadata
class Raster < ActiveFedora::Base
  include ::GeoConcerns::RasterBehavior
end
