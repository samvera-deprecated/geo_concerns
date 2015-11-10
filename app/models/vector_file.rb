# Generated via
#  `rails generate curation_concerns:work VectorFile`
class VectorFile < ActiveFedora::Base
  include ::CurationConcerns::WorkBehavior
  include ::CurationConcerns::BasicMetadata
  validates :cartographic_projection, presence: { message: 'Your work must have a cartographic projection.' }
end
