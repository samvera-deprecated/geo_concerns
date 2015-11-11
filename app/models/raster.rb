# Generated via
#  `rails generate curation_concerns:work Raster`
class Raster < ActiveFedora::Base
  include ::CurationConcerns::WorkBehavior
  include ::RasterBehavior
  include ::CurationConcerns::BasicMetadata
  include ::BasicGeoMetadata
end
