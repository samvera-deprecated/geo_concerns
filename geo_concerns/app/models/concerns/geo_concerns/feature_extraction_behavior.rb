module GeoConcerns
  module FeatureExtractionBehavior
    extend ActiveSupport::Concern
    include ::CurationConcerns::GenericWorkBehavior
    include ::CurationConcerns::BasicMetadata
    include ::GeoConcerns::BasicGeoMetadata
    include ::GeoConcerns::GeoreferencedBehavior

    # associated_with :raster (derived from, required)

    # property :transcribedBy, String
    # ...
  end
end
