# Attributes and methods for vector metadata files
module ExternalMetadataFileBehavior
  extend ActiveSupport::Concern

  included do
    type [Hydra::PCDM::Vocab::PCDMTerms.Object,
          Hydra::Works::Vocab::WorksTerms.GenericFile,
          "http://projecthydra.org/geoconcerns/models#ExternalMetadataFile"]
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
    false
  end

  def vector_file?
    false
  end

  def external_metadata_file?
    true
  end
end
