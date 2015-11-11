# Attributes and methods for image works
module ImageBehavior
  extend ActiveSupport::Concern
  included do
    type [Hydra::PCDM::Vocab::PCDMTerms.Object,
          Hydra::Works::Vocab::WorksTerms.GenericWork,
          "http://projecthydra.org/geoconcerns/models#Image"]
    filters_association :members, as: :image_file, condition: :image_file?
    filters_association :members, as: :metadata_files, condition: :external_metadata_file?
    filters_association :members, as: :rasters, condition: :raster?
  end

  # Defines type by what it is and isn't

  # This is an Image Resource
  # @return [Boolean]
  def image?
    true
  end

  # This is not an ImageFile Resource
  # @return [Boolean]
  def image_file?
    false
  end

  # This is not an ImageFile Resource
  # @return [Boolean]
  def raster?
    false
  end

  # This is not an ImageFile Resource
  # @return [Boolean]
  def raster_file?
    false
  end

  # This is not an ImageFile Resource
  # @return [Boolean]
  def vector?
    false
  end

  # This is not an ImageFile Resource
  # @return [Boolean]
  def vector_file?
    false
  end

  # This is not an ExternalMetadataFile Resource
  # @return [Boolean]
  def external_metadata_file?
    false
  end

  # #get types of members
  # def image_file
  #   members.select(&:image_file?)
  # end
  # def image_file_id
  #   image_file.map(&:id)
  # end
  # def metadata_files
  #   members.select(&:external_metadata_file?)
  # end
  # def metadata_files_ids
  #   metadata_files.map(&:id)
  # end
  # def rasters
  #   members.select(&:raster?)
  # end
  # def rasters_ids
  #   rasters.map(&:id)
  # end
end
