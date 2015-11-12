# Generated via
#  `rails generate curation_concerns:work Image`
class Image < ActiveFedora::Base
  include ::CurationConcerns::WorkBehavior
  include ::ImageBehavior
  include ::CurationConcerns::BasicMetadata
  include ::BasicGeoMetadata
end
