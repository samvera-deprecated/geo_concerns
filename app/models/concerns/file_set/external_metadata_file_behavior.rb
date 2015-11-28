# Attributes and methods for vector metadata files
module ExternalMetadataFileBehavior
  extend ActiveSupport::Concern
  include ::Iso19139Helper
  include ::FgdcHelper
  include ::ModsHelper
  # Extracts properties from the constitutent external metadata file
  # @return [Hash]
  def extract_metadata
    fn = "extract_#{geo_file_format.downcase}_metadata"
    if respond_to?(fn.to_sym)
      send(fn, metadata_xml)
    else
      fail "Unsupported metadata standard: #{geo_file_format}"
    end
  end

  # Retrives data from PCDM::File
  def metadata_xml
    Nokogiri::XML(original_file.content)
  end
end
