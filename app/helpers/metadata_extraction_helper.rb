module MetadataExtractionHelper
  # Extracts properties from the constitutent external metadata file
  # @return [Hash]
  def extract_metadata
    return {} if metadata_files.blank?
    fail NotImplementedError if metadata_files.length > 1 # TODO: Does not support multiple external metadata files
    h = metadata_files.first.extract_metadata
    h.each do |k, v|
      send("#{k}=".to_sym, v) # set each property
    end
    h
  end
end
