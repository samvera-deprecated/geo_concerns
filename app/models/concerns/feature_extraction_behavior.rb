# Attributes and methods for vector feature extractions
module FeatureExtractionBehavior
  extend ActiveSupport::Concern
  include ::CurationConcerns::WorkBehavior
  include ::CurationConcerns::BasicMetadata
  include ::BasicGeoMetadata
  include ::GeoreferencedBehavior
end
