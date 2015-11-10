# Generated via
#  `rails generate curation_concerns:work RasterFile`
class RasterFile < ActiveFedora::Base
  include ::CurationConcerns::WorkBehavior
  include ::CurationConcerns::BasicMetadata
  validates :cartographic_projection, presence: { message: 'Your work must have a cartographic projection.' }
end
