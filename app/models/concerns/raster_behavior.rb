# Attributes and methods for raster works
module RasterBehavior
  extend ActiveSupport::Concern
  include ::CurationConcerns::GenericWorkBehavior
  include ::CurationConcerns::BasicMetadata
  include ::BasicGeoMetadata

  included do
    type [Hydra::PCDM::Vocab::PCDMTerms.Object, 
      Hydra::Works::Vocab::WorksTerms.GenericWork,
      "http://projecthydra.org/geoconcerns/models#Raster"]

    #specifiy the types of members
    filters_association :members, as: :raster_file, condition: :concerns_raster_file?
    filters_association :members, as: :external_metadata_files, condition: :concerns_external_metadata_file?
    filters_association :members, as: :vector_works, condition: :concerns_vector?
  end

 # Defines type by what it is and isn't
  # @return [Boolean]
  def concerns_geospatial?
    false
  end
  def concerns_image?
    false
  end
  def concerns_image_file?
    false
  end
  def concerns_raster?
    true
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

  # Retrieve all Image Works for which georeferencing generates this Raster Work
  # @return [Array]
  def images
    aggregated_by.select { |parent| parent.class.included_modules.include?(::ImageBehavior) }
  end

  # Retrieve the only Image Works for which georeferencing generates this Raster Work
  # @return [GeoConcerns::Image]
  def image
    images.first
  end
end
