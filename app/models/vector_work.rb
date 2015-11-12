# Generated via
#  `rails generate curation_concerns:work Vector`
class VectorWork < ActiveFedora::Base
  include ::CurationConcerns::WorkBehavior
  include ::VectorWorkBehavior
  include ::CurationConcerns::BasicMetadata
  include ::BasicGeoMetadata
  include ::GeoreferencedBehavior
end
