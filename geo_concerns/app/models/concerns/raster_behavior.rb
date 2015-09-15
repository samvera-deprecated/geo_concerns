
module RasterBehavior
  extend ActiveSupport::Concern
  include ::CurationConcerns::GenericWorkBehavior
  include ::CurationConcerns::BasicMetadata
  include ::BasicGeoMetadata

  included do
    aggregates :vectors, predicate: RDF::Vocab::ORE.aggregates,
                         class_name: '::Vector',
                         type_validator: type_validator
    aggregates :metadata_files, predicate: RDF::Vocab::ORE.aggregates,
                                class_name: '::RasterMetadataFile',
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

  def images
    aggregated_by.select { |parent| parent.class.included_modules.include?(::ImageBehavior) }
  end

  def image
    images.first
  end
end
