module VectorBehavior
  extend ActiveSupport::Concern
  include ::CurationConcerns::GenericWorkBehavior
  include ::CurationConcerns::BasicMetadata
  include ::BasicGeoMetadata

  included  do
    # property :primaryCrs, String
    # property :attributeTable, Array
    # ...
  end
end
