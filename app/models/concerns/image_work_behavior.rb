# Attributes and methods for image works
module ImageWorkBehavior
  extend ActiveSupport::Concern
  included do
    type [Hydra::PCDM::Vocab::PCDMTerms.Object,
          Hydra::Works::Vocab::WorksTerms.GenericWork,
          "http://projecthydra.org/geoconcerns/models#Image"]
  end

  def image_file
    members.select(&:image_file?).to_a.first
  end

  def metadata_files
    members.select(&:external_metadata_file?)
  end

  def rasters
    members.select(&:raster?)
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

  # Extracts properties from the constitutent external metadata file
  # @return [Hash]
  # TODO: Does not support multiple external metadata files
  def extract_metadata
    return {} if metadata_files.blank?
    h = metadata_files.first.extract_metadata
    h.each do |k, v|
      send("#{k}=".to_sym, v) # set each property
    end
    h
  end
end
