# Model for external files specifying metadata for (Works of) geospatial Vector features
class VectorMetadataFile < ActiveFedora::Base
  include ::GeoConcerns::VectorMetadataFileBehavior
end
