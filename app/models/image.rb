# Generated via
#  `rails generate curation_concerns:work Image`
class Image < ActiveFedora::Base
  include ::CurationConcerns::WorkBehavior
  include ::ImageBehavior
  include ::CurationConcerns::BasicMetadata
  include ::BasicGeoWorksMetadata
  validates :title, presence: { message: 'Your work must have a title.' }
  validates :bounding_box, presence: { message: 'Your work must have a bounding box.' }
end
