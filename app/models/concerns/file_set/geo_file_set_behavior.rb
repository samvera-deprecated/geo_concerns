module GeoFileSetBehavior
  extend ActiveSupport::Concern
  include ::GeoFileFormatBehavior
  include ::ImageFileBehavior
  include ::RasterFileBehavior
  include ::VectorFileBehavior
  include ::ExternalMetadataFileBehavior
end
