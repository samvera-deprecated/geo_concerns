# Attributes and methods for vector files
module VectorFileBehavior
  extend ActiveSupport::Concern
  include Hydra::Works::GenericFileBehavior
  include ::CurationConcerns::GenericFileBehavior
  include ::BasicGeoMetadata
  include ::GeoreferencedBehavior

  included do
    type [Hydra::PCDM::Vocab::PCDMTerms.Object,
      Hydra::Works::Vocab::WorksTerms.GenericFile,
      "http://projecthydra.org/geoconcerns/models#VectorFile"]
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
    false
  end
  def concerns_vector_file?
    true
  end
  def concerns_external_metadata_file?
    false
  end

  # Retrieve the Vector Work of which this Object is a member
  # @return [GeoConcerns::Vector]
  def vector
    parents.find { |parent| parent.class.included_modules.include?(::VectorBehavior) }
  end
end
