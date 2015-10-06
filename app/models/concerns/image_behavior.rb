# Attributes and methods for image works
module ImageBehavior
  extend ActiveSupport::Concern
  include ::CurationConcerns::GenericWorkBehavior
  include ::CurationConcerns::BasicMetadata
  include ::BasicGeoMetadata

  included do
    type [Hydra::PCDM::Vocab::PCDMTerms.Object,
      Hydra::Works::Vocab::WorksTerms.GenericWork,
      Vocab::GeoTerms.Image]

    #specifiy the types of members
    filters_association :members, as: :image_file, condition: :isType?(:concerns_image_file)
    filters_association :members, as: :external_metadata_files, condition: :isType?(:concerns_metadata_file)
    filters_association :members, as: :raster_works, condition: :isType?(:concerns_raster)
  end

 # Inspects whether or not this Object is a ImageWork
  # @return [Boolean]
  def isType?(type)
    return true if type==:concerns_image
    return false
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
