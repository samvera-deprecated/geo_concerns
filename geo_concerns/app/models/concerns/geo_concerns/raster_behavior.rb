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

      aggregates :images, predicate: RDF::Vocab::ORE.aggregates,
                          class_name: 'GeoConcerns::Image',
                          type_validator: type_validator
      filters_association :members, as: :raster_files, condition: :concerns_raster_file?
    end

    def concerns_raster?
      true
    end

    # @return [Boolean] whether this instance is a GeoConcerns Raster File.
    def concerns_raster_file?
      false
    end

    def image
      # Work-around for "Couldn't find ActiveFedora::Base without an ID" ArgumentError when using Array#find
      image_set = images.select { |parent| parent.class.included_modules.include?(GeoConcerns::ImageBehavior) }
      image_set.first
    end

    def vectors
      aggregated_by.select { |parent| parent.class.included_modules.include?(GeoConcerns::VectorBehavior) }
    end
  end
end
