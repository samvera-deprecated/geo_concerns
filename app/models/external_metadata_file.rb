# Generated via
#  `rails generate curation_concerns:work ExternalMetadataFile`
class ExternalMetadataFile < ActiveFedora::Base
  include ::CurationConcerns::WorkBehavior
  include ::CurationConcerns::BasicMetadata
  include ::ExternalMetadataFileBehavior
  validates :conforms_to, presence: { message: 'Your work must specify the metadata standard.' }
end
