# Attributes and methods for vector works
module VectorWorkBehavior
  extend ActiveSupport::Concern
  included do
    type [Hydra::PCDM::Vocab::PCDMTerms.Object,
          Hydra::Works::Vocab::WorksTerms.GenericWork,
          "http://projecthydra.org/geoconcerns/models#Vector"]
  end

  def vector_files
    members.select(&:vector_file?)
  end

  def metadata_files
    members.select(&:external_metadata_file?)
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
    false
  end

  def raster_file?
    false
  end

  def vector?
    true
  end

  def vector_file?
    false
  end

  def external_metadata_file?
    false
  end

  # Retrieve all Raster Works for which this Vector Work can be extracted
  # @return [Array]
  def rasters
    aggregated_by.select { |parent| parent.class.included_modules.include?(::RasterBehavior) }
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
