# Attributes and methods for raster files
module RasterFileBehavior
  extend ActiveSupport::Concern
  # Retrieve the JPEG preview for the raster data set
  # @return [Hydra::PCDM::File]
  # @see Hydra::Works::GenericFile#thumbnail
  def preview
    thumbnail
  end

  # Retrieve the Raster Work of which this Object is a member
  # @return [GeoConcerns::Raster]
  def raster_work
    generic_works.find { |parent| parent.class.included_modules.include?(::RasterWorkBehavior) }
  end
end
