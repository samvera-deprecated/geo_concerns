module GeoFileSetBehavior
  extend ActiveSupport::Concern
  include ::GeoFileFormatBehavior
  include ::ImageFileBehavior
  include ::RasterFileBehavior
  include ::VectorFileBehavior
  include ::ExternalMetadataFileBehavior

  # Accessor for the UUID
  alias_attribute :uuid, :id

  def to_solr
    solr_doc = super
    Solrizer.set_field(solr_doc, 'uuid', id, :stored_sortable)
    solr_doc
  end
end
