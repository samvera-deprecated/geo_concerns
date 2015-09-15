# Model for external files specifying metadata for (Works of) Raster geospatial data sets
class RasterMetadataFile < ActiveFedora::Base
  include ::GeoConcerns::RasterMetadataFileBehavior
end
