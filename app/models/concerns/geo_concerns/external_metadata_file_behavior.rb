module GeoConcerns
  # Attributes and methods for vector metadata files
  module ExternalMetadataFileBehavior
    extend ActiveSupport::Concern
    include ::GeoConcerns::Extractors::Iso19139Helper
    include ::GeoConcerns::Extractors::FgdcHelper
    include ::GeoConcerns::Extractors::ModsHelper

    # Extracts properties from the constitutent external metadata file
    # @example
    #   extract_iso19139_metadata
    #   extract_fgdc_metadata
    #   extract_mods_metadata
    # @return [Hash]
    def extract_metadata
      raise ArgumentError, "MIME type unspecified or not configured" if schema.blank?
      fn = "extract_#{schema.downcase}_metadata"
      raise ArgumentError, "Unsupported metadata standard: #{schema}" unless respond_to?(fn.to_sym)
      send(fn, metadata_xml)
    end

    # Retrives data from PCDM::File
    def metadata_xml
      Nokogiri::XML(original_file.content)
    end

    def schema
      (MetadataFormatService.label(mime_type) || '').parameterize('_')
    end
  end
end
