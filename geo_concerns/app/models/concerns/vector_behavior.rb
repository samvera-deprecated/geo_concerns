# Attributes and methods for vector works
module VectorBehavior
  extend ActiveSupport::Concern
  include ::CurationConcerns::GenericWorkBehavior
  include ::CurationConcerns::BasicMetadata
  include ::BasicGeoMetadata

  included do
    # Vector Works can aggregate one or many metadata files
    aggregates :metadata_files, predicate: RDF::Vocab::ORE.aggregates,
                                class_name: '::VectorMetadataFile',
                                type_validator: type_validator

    # Vector Works can only link to GenericFile resources as members if they are instances of GeoConcerns::VectorFile
    filters_association :members, as: :vector_files, condition: :concerns_vector_file?
  end

  # Inspects whether or not this Object is a Vector Work
  # @return [Boolean]
  def concerns_vector?
    true
  end

  # Inspects whether or not this Object is a Vector File
  # @return [Boolean]
  def concerns_vector_file?
    false
  end

  # Retrieve all Raster Works for which this Vector Work can be extracted
  # @return [Array]
  def rasters
    aggregated_by.select { |parent| parent.class.included_modules.include?(::RasterBehavior) }
  end
end
