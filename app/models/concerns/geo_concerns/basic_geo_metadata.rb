module GeoConcerns
  # Attributes and methods for basic geospatial metadata used by Works
  module BasicGeoMetadata
    extend ActiveSupport::Concern

    included do
      apply_schema ::GeoConcerns::BasicGeoMetadataRequired,
                   ActiveFedora::SchemaIndexingStrategy.new(
                     ActiveFedora::Indexers::GlobalIndexer.new(
                       [:stored_searchable, :facetable, :symbol]
                     )
                   )
      apply_schema ::GeoConcerns::BasicGeoMetadataOptional,
                   ActiveFedora::SchemaIndexingStrategy.new(
                     ActiveFedora::Indexers::GlobalIndexer.new(
                       [:stored_searchable, :facetable, :symbol]
                     )
                   )
    end

    # Return a Hash representation of this object where keys in the hash are appropriate Solr field names.
    # @param [Hash] _solr_doc (optional) Hash to insert the fields into
    # If opts[:model_only] == true, the base object metadata and the RELS-EXT datastream will be omitted.  This is mainly to support shelver, which calls #to_solr for each model an object subscribes to.
    def to_solr(_solr_doc = {})
      solr_doc = super(_solr_doc)

      # Required fields
      solr_doc["uuid"] = id
      solr_doc["dc_identifier_s"] = identifier.first
      solr_doc["dc_title_s"] = title.first
      solr_doc["dc_description_s"] = description.first
      solr_doc["dc_rights_s"] = rights.first
      solr_doc["dct_provenance_s"] = provenance
      solr_doc["dct_references_s"] = references
      solr_doc["georss_box_s"] = coverage
      solr_doc["layer_id_s"] = references
      solr_doc["layer_geom_type_s"] = resource_type.first
      solr_doc["layer_modified_dt"] = date_modified
      solr_doc["layer_slug_s"] = id
      solr_doc["solr_geom"] = coverage
      solr_doc["solr_year_i"] = temporal

      # Optional fields
      solr_doc["dc_creator_sm"] = creator
      solr_doc["dc_format_s"] = format
      solr_doc["dc_language_s"] = language.first
      solr_doc["dc_publisher_s"] = publisher.first
      solr_doc["dc_subject_sm"] = subject.first
      solr_doc["dc_type_s"] = resource_type.first
      solr_doc["dct_spatial_sm"] = spatial
      solr_doc["dct_temporal_sm"] = temporal
      solr_doc["dct_issued_dt"] = issued
      solr_doc["dct_isPartOf_sm"] = part_of
      solr_doc["dc_coverage_s"] = coverage
      solr_doc
    end
  end
end
