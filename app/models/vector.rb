# Generated via
#  `rails generate curation_concerns:work Vector`
class Vector < ActiveFedora::Base
  include ::CurationConcerns::WorkBehavior
  include ::VectorBehavior
  include ::CurationConcerns::BasicMetadata
  include ::BasicGeoMetadata
  validates :title, presence: { message: 'Your work must have a title.' }
end
