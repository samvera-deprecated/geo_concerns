# Attributes and methods for basic geospatial metadata used by Works
module BasicGeoMetadata
  extend ActiveSupport::Concern

  included do
    apply_schema BasicGeoMetadataRequired, ActiveFedora::SchemaIndexingStrategy.new(
      ActiveFedora::Indexers::GlobalIndexer.new([:stored_searchable, :facetable, :symbol])
    )
    apply_schema BasicGeoMetadataOptional, ActiveFedora::SchemaIndexingStrategy.new(
      ActiveFedora::Indexers::GlobalIndexer.new([:stored_searchable, :facetable, :symbol])
    )
  end
end
