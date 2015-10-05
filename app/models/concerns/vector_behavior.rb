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
    filters_association :members, as: :vector_files, condition: :vector_file?
    filters_association :members, as: :metadata_files, condition: :external_metadata_file?
  end

 # Defines type by what it is and isn't
  # @return [Boolean]
  def image?
    false
  end
  def image_file?
    false
  end
  def raster?
    false
  end
  def raster_file?
    false
  end
  def vector?
    true
  end
  def vector_file?
    false
  end
  def external_metadata_file?
    false
  end

  # Retrieve all Raster Works for which this Vector Work can be extracted
  # @return [Array]
  def rasters
    aggregated_by.select { |parent| parent.class.included_modules.include?(::RasterBehavior) }
  end
end