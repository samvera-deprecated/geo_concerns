# Generated via
#  `rails generate curation_concerns:work ExternalMetadataFile`
class ExternalMetadataFile < ActiveFedora::Base
  include ::CurationConcerns::FileSetBehavior
  include ::CurationConcerns::BasicMetadata
  include ::ExternalMetadataFileBehavior
end
