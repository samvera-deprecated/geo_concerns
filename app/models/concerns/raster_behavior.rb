# Attributes and methods for raster works
module RasterBehavior
  extend ActiveSupport::Concern
  included do
    type [Hydra::PCDM::Vocab::PCDMTerms.Object,
          Hydra::Works::Vocab::WorksTerms.GenericWork,
          "http://projecthydra.org/geoconcerns/models#Raster"]
  end

  def raster_files
    members.select(&:raster_file?)
  end

  def metadata_files
    members.select(&:external_metadata_file?)
  end

  def vectors
    members.select(&:vector?)
  end

  # Defines type by what it is and isn't
  # @return [Boolean]
  def image?
    false
  end

  def image_file?
    false
  end

  def raster?
    true
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
