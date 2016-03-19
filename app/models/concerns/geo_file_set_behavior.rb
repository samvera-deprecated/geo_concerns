module GeoFileSetBehavior
  extend ActiveSupport::Concern
  include ::GeoFileFormatBehavior
  include ::ImageFileBehavior
  include ::RasterFileBehavior
  include ::VectorFileBehavior
  include ::ExternalMetadataFileBehavior

  included do
    apply_schema BasicGeoMetadataFileSet, ActiveFedora::SchemaIndexingStrategy.new(
      ActiveFedora::Indexers::GlobalIndexer.new([:stored_searchable, :facetable, :symbol])
    )
  end
end
