# Generated via
#  `rails generate curation_concerns:work VectorWork`
class VectorWork < ActiveFedora::Base
  include ::CurationConcerns::WorkBehavior
  include ::GeoConcerns::VectorWorkBehavior
  include ::CurationConcerns::BasicMetadata
  include ::GeoConcerns::BasicGeoMetadata
  include ::GeoConcerns::GeoreferencedBehavior
end
