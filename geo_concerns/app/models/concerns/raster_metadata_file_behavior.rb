
module RasterMetadataFileBehavior
  extend ActiveSupport::Concern
  include Hydra::Works::GenericFileBehavior
  include ::CurationConcerns::GenericFileBehavior
  include ::MetadataFileBehavior

  def raster
    aggregated_by.find { |parent| parent.class.included_modules.include?(GeoConcerns::RasterBehavior) }
  end
end
