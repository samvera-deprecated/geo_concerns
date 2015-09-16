# Attributes and methods for image works
module ImageBehavior
  extend ActiveSupport::Concern
  include ::CurationConcerns::GenericWorkBehavior
  include ::CurationConcerns::BasicMetadata
  include ::BasicGeoMetadata

  included do
    # Image Works can aggregate one or many Raster Works
    # This provides the the ability to link raster data sets projected to different CRS's to the source images for which they were georeferenced
    aggregates :rasters, predicate: RDF::Vocab::ORE.aggregates,
                         class_name: '::Raster',
                         type_validator: type_validator

    # Image Works can only link to GenericFile resources as members if they are instances of GeoConcerns::ImageFile
    filters_association :members, as: :image_files, condition: :concerns_image_file?
  end

  # Inspects whether or not this Object is an Image Work
  # @return [Boolean]
  def concerns_image?
    true
  end

  # Inspects whether or not this Object is a Image File
  # @return [Boolean]
  def concerns_image_file?
    false
  end

  # Retrieve the only the first Image File managing metadata in relation to the content of a bitstream
  # @return [GeoConcerns::ImageFile]
  def image_file
    image_files.first
  end

  # Overrides the mutation of the Image Files managed for this work
  # (Ensures that a single ImageFile instance is related from within an Array)
  # @param _file [ImageFile] the Image File to be related
  def image_file=(_file)
    image_files=([_file])
  end
end
