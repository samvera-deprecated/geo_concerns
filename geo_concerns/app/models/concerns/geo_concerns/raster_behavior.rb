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

      filters_association :members, as: :raster_files, condition: :concerns_raster_file?
      # filters_association :aggregated_by, as: :vectors, condition: :concerns_vector?
    end

    def concerns_raster?
      true
    end

    # @return [Boolean] whether this instance is a GeoConcerns Raster File.
    def concerns_raster_file?
      false
    end

    # def raster_files
    #  members
    # end

    def image
      aggregated_by.find { |parent| parent.class.included_modules.include?(GeoConcerns::ImageBehavior) }
    end

    def vectors
      aggregated_by.select { |parent| parent.class.included_modules.include?(GeoConcerns::VectorBehavior) }
    end
  end
end
