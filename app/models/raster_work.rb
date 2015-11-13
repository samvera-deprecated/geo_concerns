# Generated via
#  `rails generate curation_concerns:work RasterWork`
class RasterWork < ActiveFedora::Base
  include ::CurationConcerns::WorkBehavior
  include ::RasterWorkBehavior
  include ::CurationConcerns::BasicMetadata
  include ::BasicGeoMetadata
  include ::GeoreferencedBehavior
end
