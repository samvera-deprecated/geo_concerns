# Attributes and methods for basic geospatial metadata used by Works
module BasicGeoMetadata
  extend ActiveSupport::Concern

  included do
    apply_schema BasicGeoMetadataRequired
    apply_schema BasicGeoMetadataOptional
  end
end
