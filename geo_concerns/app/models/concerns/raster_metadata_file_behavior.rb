# Attributes and methods for raster metadata files
module RasterMetadataFileBehavior
  extend ActiveSupport::Concern
  include Hydra::Works::GenericFileBehavior
  include ::CurationConcerns::GenericFileBehavior
  include ::MetadataFileBehavior

  # Retrieve the Raster Work of which this Object is a member
  # @return [GeoConcerns::Raster]
  def raster
    aggregated_by.find { |parent| parent.class.included_modules.include?(GeoConcerns::RasterBehavior) }
  end
end
