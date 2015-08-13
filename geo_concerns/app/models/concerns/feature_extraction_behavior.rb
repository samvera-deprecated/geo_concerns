module FeatureExtractionBehavior
  extend ActiveSupport::Concern
  include ::CurationConcerns::GenericWorkBehavior
  include ::CurationConcerns::BasicMetadata
  include ::BasicGeoMetadata

  # associated_with :raster (derived from, required)

  included  do
    # property :transcribedBy, String
    # ...
  end
end
