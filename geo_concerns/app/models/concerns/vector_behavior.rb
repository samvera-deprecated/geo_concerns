module VectorBehavior
  extend ActiveSupport::Concern
  include ::CurationConcerns::GenericWorkBehavior
  include ::CurationConcerns::BasicMetadata
  include ::BasicGeoMetadata
  include ::GeoreferencedBehavior

  included  do
    # property :attributeTable, Array
    # ...
  end
end
