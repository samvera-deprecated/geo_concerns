# Attributes and methods for vector files
module VectorFileBehavior
  extend ActiveSupport::Concern

  included do
    type [Hydra::PCDM::Vocab::PCDMTerms.Object,
          Hydra::Works::Vocab::WorksTerms.GenericFile,
          'http://projecthydra.org/geoconcerns/models#VectorFile']
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
    false
  end

  def vector_file?
    true
  end

  def external_metadata_file?
    false
  end

  # Retrieve the Vector Work of which this Object is a member
  # @return [GeoConcerns::VectorWork]
  def vector_work
    generic_works.find { |parent| parent.class.included_modules.include?(::VectorWorkBehavior) }
  end
end
