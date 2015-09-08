module GeoConcerns
  module RasterFileBehavior
    extend ActiveSupport::Concern
    include Hydra::Works::GenericFileBehavior # Added
    include ::CurationConcerns::GenericFileBehavior
    include ::GeoConcerns::BasicGeoMetadata
    include ::GeoConcerns::GeoreferencedBehavior

    included do
      # associated_with :image (derived from, optional)

      # property :resolution, Float
      # ...
    end

    # @return [Boolean] whether this instance is a Hydra::Works Generic File.
    def works_raster_file?
      true
    end
  end
end
