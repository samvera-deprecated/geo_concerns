
module RasterFileBehavior
  extend ActiveSupport::Concern
  include Hydra::Works::GenericFileBehavior # Added
  include ::CurationConcerns::GenericFileBehavior
  include ::BasicGeoMetadata
  include ::GeoreferencedBehavior

  # @return [Boolean] whether this instance is a GeoConcerns Raster File.
  def concerns_raster_file?
    true
  end

  # Aliases the thumbnail method
  def preview
    thumbnail
  end

  def raster
    parents.find { |parent| parent.class.included_modules.include?(::RasterBehavior) }
  end
end
