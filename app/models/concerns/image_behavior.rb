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
    filters_association :members, as: :image_file, condition: :image_file?
    filters_association :members, as: :metadata_files, condition: :external_metadata_file?
    filters_association :members, as: :rasters, condition: :raster?
  end

 # Defines type by what it is and isn't
  # @return [Boolean]
  def image?
    true
  end
  def image_file?
    false
  end
  def raster?
    false
  end
  def raster_file?
    false
  end
  def vector?
    false
  end
  def vector_file?
    false
  end
  def external_metadata_file?
    false
  end
end
