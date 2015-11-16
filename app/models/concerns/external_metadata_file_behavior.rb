# Attributes and methods for vector metadata files
module ExternalMetadataFileBehavior
  extend ActiveSupport::Concern

  included do
    # Specifies the metadata standard to which the metadata file conforms
    # @see http://dublincore.org/documents/dcmi-terms/#terms-conformsTo
    property :conforms_to, predicate: ::RDF::DC.conformsTo do |index|
      index.as :stored_searchable, :facetable
    end

    type [Hydra::PCDM::Vocab::PCDMTerms.Object,
          Hydra::Works::Vocab::WorksTerms.GenericFile,
          Vocab::GeoTerms.ExternalMetadataFile]
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
    false
  end

  def external_metadata_file?
    true
  end
end
