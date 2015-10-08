# Attributes and methods for vector works
module VectorBehavior
  extend ActiveSupport::Concern
  include ::CurationConcerns::GenericWorkBehavior
  include ::CurationConcerns::BasicMetadata
  include ::BasicGeoMetadata

  included do
    type [Hydra::PCDM::Vocab::PCDMTerms.Object,
      Hydra::Works::Vocab::WorksTerms.GenericWork,
      "http://projecthydra.org/geoconcerns/models#Vector"]

    #specifiy the types of members
    filters_association :members, as: :vector_file, condition: :concerns_vector_file?
    filters_association :members, as: :external_metadata_files, condition: :concerns_external_metadata_file?
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
    false
  end
  def concerns_raster_file?
    false
  end
  def concerns_vector?
    true
  end
  def concerns_vector_file?
    false
  end
  def concerns_external_metadata_file?
    false
  end

  # Retrieve all Raster Works for which this Vector Work can be extracted
  # @return [Array]
  def rasters
    aggregated_by.select { |parent| parent.class.included_modules.include?(::RasterBehavior) }
  end
end