# Attributes and methods for raster works
module RasterBehavior
  extend ActiveSupport::Concern
  include ::CurationConcerns::GenericWorkBehavior
  include ::CurationConcerns::BasicMetadata
  include ::BasicGeoMetadata

  included do
    # Raster Works can aggregate one or many Vector Works
    # This provides the the ability to link extracted vector features projected to different CRS's to the source raster data set
    aggregates :vectors, predicate: RDF::Vocab::ORE.aggregates,
                         class_name: '::Vector',
                         type_validator: type_validator
    
    # Raster Works can aggregate one or many metadata files
    aggregates :metadata_files, predicate: RDF::Vocab::ORE.aggregates,
                                class_name: '::RasterMetadataFile',
                                type_validator: type_validator

    # Raster Works can only link to GenericFile resources as members if they are instances of GeoConcerns::RasterFile
    filters_association :members, as: :raster_files, condition: :concerns_raster_file?
  end

  # Inspects whether or not this Object is a Raster Work
  # @return [Boolean]
  def concerns_raster?
    true
  end

  # Inspects whether or not this Object is a Raster File
  # @return [Boolean]
  def concerns_raster_file?
    false
  end

  # Retrieve all Image Works for which georeferencing generates this Raster Work
  # @return [Array]
  def images
    aggregated_by.select { |parent| parent.class.included_modules.include?(::ImageBehavior) }
  end

  # Retrieve the only Image Works for which georeferencing generates this Raster Work
  # @return [GeoConcerns::Image]
  def image
    images.first
  end
end
