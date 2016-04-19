module GeoFileSetBehavior
  extend ActiveSupport::Concern
  include ::GeoFileFormatBehavior
  include ::ImageFileBehavior
  include ::RasterFileBehavior
  include ::VectorFileBehavior
  include ::ExternalMetadataFileBehavior

  def to_solr
    solr_doc = super
    # solr_doc[:uuid] = id
    solr_doc
  end
end
