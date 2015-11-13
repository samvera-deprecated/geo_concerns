# Attributes and methods for image works
module ImageWorkBehavior
  extend ActiveSupport::Concern
  include ::MetadataExtractionHelper

  included do
    type [Hydra::PCDM::Vocab::PCDMTerms.Object,
          Hydra::Works::Vocab::WorksTerms.GenericWork,
          ::Vocab::GeoTerms.ImageWork]
  end

  def image_file
    members.select(&:image_file?).to_a.first
  end

  def metadata_files
    members.select(&:external_metadata_file?)
  end

  def raster_works
    members.select(&:raster_work?)
  end

  # Defines type by what it is and isn't

  # This is an Image Resource
  # @return [Boolean]
  def image?
    true
  end

  # This is not an ImageFile Resource
  # @return [Boolean]
  def image_file?
    false
  end

  # This is not an ImageFile Resource
  # @return [Boolean]
  def raster_work?
    false
  end

  # This is not an ImageFile Resource
  # @return [Boolean]
  def raster_file?
    false
  end

  # This is not an ImageFile Resource
  # @return [Boolean]
  def vector_work?
    false
  end

  # This is not an ImageFile Resource
  # @return [Boolean]
  def vector_file?
    false
  end

  # This is not an ExternalMetadataFile Resource
  # @return [Boolean]
  def external_metadata_file?
    false
  end
end
