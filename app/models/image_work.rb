# Generated via
#  `rails generate curation_concerns:work ImageWork`
class ImageWork < ActiveFedora::Base
  include ::CurationConcerns::WorkBehavior
  include ::ImageWorkBehavior
  include ::CurationConcerns::BasicMetadata
  include ::BasicGeoMetadata
end
