# Generated via
#  `rails generate curation_concerns:work Raster`
class Raster < ActiveFedora::Base
  include ::CurationConcerns::WorkBehavior
  include ::RasterBehavior
  include ::CurationConcerns::BasicMetadata
  include ::BasicGeoMetadata
  validates :title, presence: { message: 'Your work must have a title.' }
end
