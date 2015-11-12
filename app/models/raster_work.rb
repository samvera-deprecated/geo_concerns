# Generated via
#  `rails generate curation_concerns:work Raster`
class RasterWork < ActiveFedora::Base
  include ::CurationConcerns::WorkBehavior
  include ::RasterWorkBehavior
  include ::CurationConcerns::BasicMetadata
  include ::BasicGeoMetadata
end
