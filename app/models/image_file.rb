# Generated via
#  `rails generate curation_concerns:work ImageFile`
class ImageFile < ActiveFedora::Base
  include ::CurationConcerns::WorkBehavior
  include ::CurationConcerns::BasicMetadata
end
