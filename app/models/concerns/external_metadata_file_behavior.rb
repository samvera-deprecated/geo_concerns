# Attributes and methods for vector metadata files
module ExternalMetadataFileBehavior
  extend ActiveSupport::Concern
  include ::Iso19139Helper
  include ::FgdcHelper
  include ::ModsHelper

  included do
    # Specifies the metadata standard to which the metadata file conforms
    # @see http://dublincore.org/documents/dcmi-terms/#terms-conformsTo
    property :conforms_to, predicate: ::RDF::Vocab::DC.conformsTo, multiple: false do |index|
      index.as :stored_searchable, :facetable
    end

    type [Hydra::PCDM::Vocab::PCDMTerms.Object,
          Hydra::Works::Vocab::WorksTerms.FileSet,
          ::Vocab::GeoTerms.ExternalMetadataFile]
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

  # Extracts properties from the constitutent external metadata file
  # @return [Hash]
  def extract_metadata
    fn = "extract_#{conforms_to.downcase}_metadata"
    if respond_to?(fn.to_sym)
      send(fn, metadata_xml)
    else
      fail "Unsupported metadata standard: #{conforms_to}"
    end
  end

  # Retrives data from PCDM::File
  def metadata_xml
    Nokogiri::XML(original_file.content)
  end
end
