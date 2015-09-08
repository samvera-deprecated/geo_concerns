module GeoConcerns
  module RasterBehavior
    extend ActiveSupport::Concern
    include ::CurationConcerns::GenericWorkBehavior
    include ::CurationConcerns::BasicMetadata
    include ::GeoConcerns::BasicGeoMetadata
    include ::GeoConcerns::GeoreferencedBehavior

    included do
      # associated_with :image (derived from, optional)

      # property :resolution, Float
      # ...

      filters_association :members, as: :raster_files, condition: :works_raster_file?
    end

    # @return [Boolean] whether this instance is a Hydra::Works Generic File.
    def works_raster_file?
      false
    end

    def rasters
      generic_works
    end
  end
end
