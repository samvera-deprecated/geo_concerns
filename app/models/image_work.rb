# Generated via
#  `rails generate curation_concerns:work Image`
class ImageWork < ActiveFedora::Base
  include ::CurationConcerns::WorkBehavior
  include ::ImageWorkBehavior
  include ::CurationConcerns::BasicMetadata
  include ::BasicGeoMetadata
end
