# Attributes and methods for image works
module GeospatialBehavior
  extend ActiveSupport::Concern
  include ::CurationConcerns::GenericWorkBehavior
  include ::CurationConcerns::BasicMetadata
  include ::BasicGeoMetadata

  included do
    type Vocab::GeoTerms.Geospatial

    #specifiy the types of members
    filters_association :members, as: :image_work, condition: :isType?(:concerns_image)
    filters_association :members, as: :raster_works, condition: :isType?(:concerns_raster)
    filters_association :members, as: :vector_works, condition: :isType?(:concerns_vector)
  end

  # Inspects whether or not this Object is a GeospatialWork
  # @return [Boolean]
  def isType?(type)
    return true if type==:concerns_geospatial
    return false
  end

  # Retrieve the 1 image
  def image_work
    image_work.first
  end

  # retrieve 
  def raster_works
    raster_works
  end

  def vector_works
    vector_works
  end

end
