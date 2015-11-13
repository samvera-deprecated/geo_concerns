# Attributes and methods for vector works
module VectorWorkBehavior
  extend ActiveSupport::Concern
  included do
    type [Hydra::PCDM::Vocab::PCDMTerms.Object,
          Hydra::Works::Vocab::WorksTerms.GenericWork,
          'http://projecthydra.org/geoconcerns/models#VectorWork']
  end

  def vector_files
    members.select(&:vector_file?)
  end

  def metadata_files
    members.select(&:external_metadata_file?)
  end

  # Defines type by what it is and isn't
  # @return [Boolean]
  def image_work?
    false
  end

  def image_file?
    false
  end

  def raster_work?
    false
  end

  def raster_file?
    false
  end

  def vector_work?
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
  def raster_works
    aggregated_by.select { |parent| parent.class.included_modules.include?(::RasterWorkBehavior) }
  end
end
