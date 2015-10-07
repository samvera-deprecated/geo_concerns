# Attributes and methods for image works
module ImageBehavior
  extend ActiveSupport::Concern
  include ::CurationConcerns::GenericWorkBehavior
  include ::CurationConcerns::BasicMetadata
  include ::BasicGeoMetadata

  included do
    type [Hydra::PCDM::Vocab::PCDMTerms.Object,
      Hydra::Works::Vocab::WorksTerms.GenericWork,
      "http://projecthydra.org/geoconcerns/models#Image"]

    #specifiy the types of members
    filters_association :members, as: :image_file, condition: :concerns_image_file?
    filters_association :members, as: :external_metadata_files, condition: :concerns_external_metadata_file?
    filters_association :members, as: :raster_works, condition: :concerns_raster?
  end

 # Defines type by what it is and isn't
  # @return [Boolean]
  def concerns_geospatial?
    false
  end
  def concerns_image?
    true
  end
  def concerns_image_file?
    false
  end
  def concerns_raster?
    false
  end
  def concerns_raster_file?
    false
  end
  def concerns_vector?
    false
  end
  def concerns_vector_file?
    false
  end
  def concerns_external_metadata_file?
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
