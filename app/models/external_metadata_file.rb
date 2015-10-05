# Model for external files specifying metadata for (Works of) geospatial Vector features
class ExternalMetadataFile < ActiveFedora::Base
  include ::GeoConcerns::ExternalMetadataFileBehavior
end
