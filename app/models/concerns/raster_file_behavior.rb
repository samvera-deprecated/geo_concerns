# Attributes and methods for raster files
module RasterFileBehavior
  extend ActiveSupport::Concern
  include Hydra::Works::GenericFileBehavior
  include ::CurationConcerns::GenericFileBehavior
  include ::BasicGeoMetadata
  include ::GeoreferencedBehavior

  # Inspects whether or not this Object is a Raster Work
  # @return [Boolean]
  def concerns_raster?
    false
  end

  # Inspects whether or not this Object is a Raster File
  # @return [Boolean]
  def concerns_raster_file?
    true
  end

  # Retrieve the JPEG preview for the raster data set
  # @return [Hydra::PCDM::File]
  # @see Hydra::Works::GenericFile#thumbnail
  def preview
    thumbnail
  end

  # Retrieve the Raster Work of which this Object is a member
  # @return [GeoConcerns::Raster]
  def raster
    parents.find { |parent| parent.class.included_modules.include?(::RasterBehavior) }
  end
end
