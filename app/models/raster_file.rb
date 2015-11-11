# Generated via
#  `rails generate curation_concerns:work RasterFile`
class RasterFile < ActiveFedora::Base
  include ::CurationConcerns::FileSetBehavior
  include ::CurationConcerns::BasicMetadata
  include ::BasicGeoMetadata
  include ::GeoreferencedBehavior
  include ::RasterFileBehavior
end
