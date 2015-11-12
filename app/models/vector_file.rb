# Generated via
#  `rails generate curation_concerns:work VectorFile`
class VectorFile < ActiveFedora::Base
  include ::CurationConcerns::FileSetBehavior
  include ::CurationConcerns::BasicMetadata
  include ::BasicGeoMetadata
  include ::GeoreferencedBehavior
  include ::VectorFileBehavior
end
