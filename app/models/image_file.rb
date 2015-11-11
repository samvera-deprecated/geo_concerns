# Generated via
#  `rails generate curation_concerns:work ImageFile`
class ImageFile < ActiveFedora::Base
  include ::CurationConcerns::FileSetBehavior
  include ::CurationConcerns::BasicMetadata
  include ::ImageFileBehavior
end
