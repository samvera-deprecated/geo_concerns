# Attributes and methods for vector metadata files
module ExternalMetadataFileBehavior
  extend ActiveSupport::Concern
  include ::Iso19139Helper
  include ::FgdcHelper
  include ::ModsHelper

  # Extracts properties from the constitutent external metadata file
  # @example
  #   extract_iso19139_metadata
  #   extract_fgdc_metadata
  #   extract_mods_metadata
  # @return [Hash]
  def extract_metadata
    fn = "extract_#{conforms_to.downcase}_metadata"
    if respond_to?(fn.to_sym)
      send(fn, metadata_xml)
    else
      fail ArgumentError, "Unsupported metadata standard: #{conforms_to}"
    end
  end

  # Retrives data from PCDM::File
  def metadata_xml
    Nokogiri::XML(original_file.content)
  end
end
