module RasterBehavior
  extend ActiveSupport::Concern
  include ::CurationConcerns::GenericWorkBehavior
  include ::CurationConcerns::BasicMetadata
  include ::BasicGeoMetadata

  # associated_with :image (derived from, optional)

  included  do
    # property :primaryCrs, String
    # property :resolution, Float
    # ...
  end
end
