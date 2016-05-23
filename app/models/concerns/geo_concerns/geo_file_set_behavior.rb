module GeoConcerns
  module GeoFileSetBehavior
    extend ActiveSupport::Concern
    include ::GeoConcerns::GeoFileFormatBehavior
    include ::GeoConcerns::ImageFileBehavior
    include ::GeoConcerns::RasterFileBehavior
    include ::GeoConcerns::VectorFileBehavior
    include ::GeoConcerns::ExternalMetadataFileBehavior
    include ::GeoConcerns::FileSetMetadata
    include ::GeoConcerns::FileSet::Derivatives
  end
end
