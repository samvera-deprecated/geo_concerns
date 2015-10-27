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

  #get types of members
  def image_file
    members.select(&:image_file?)
  end
  def image_file_id
    image_file.map(&:id)
  end
  def metadata_files
    members.select(&:external_metadata_file?)
  end
  def metadata_files_ids
    metadata_files.map(&:id)
  end
  def rasters
    members.select(&:raster?)
  end
  def rasters_ids
    rasters.map(&:id)
  end
end
