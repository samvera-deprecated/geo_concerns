# Attributes and methods for image works
module GeospatialBehavior
  extend ActiveSupport::Concern
  include ::CurationConcerns::GenericWorkBehavior
  include ::CurationConcerns::BasicMetadata
  include ::BasicGeoMetadata

  included do
    type [Hydra::PCDM::Vocab::PCDMTerms.Object,
      Hydra::Works::Vocab::WorksTerms.GenericWork,
      "http://projecthydra.org/geoconcerns/models#Geospatial"]

    #specifiy the types of members
    filters_association :members, as: :image_work, condition: :concerns_image?
    filters_association :members, as: :raster_works, condition: :concerns_raster?
    filters_association :members, as: :vector_works, condition: :concerns_vector?
  end

 # Defines type by what it is and isn't
  # @return [Boolean]
  def concerns_geospatial?
    true
  end
  def concerns_image?
    false
  end
  def concerns_image_file?
    false
  end
  def concerns_raster?
    false
  end
  def concerns_raster_file?
    false
  end
  def concerns_vector?
    false
  end
  def concerns_vector_file?
    false
  end
  def concerns_external_metadata_file?
    false
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
