module MetadataExtractionHelper
  # Extracts properties from the constitutent external metadata file
  # @return [Hash]
  def extract_metadata
    return {} if metadata_files.blank?
    fail NotImplementedError if metadata_files.length > 1 # TODO: Does not support multiple external metadata files
    metadata_files.first.extract_metadata
  end

  # Sets properties from the constitutent external metadata file
  def populate_metadata
    extract_metadata.each do |k, v|
      send("#{k}=".to_sym, v) # set each property
    end
  end

  attr_reader :should_populate_metadata

  def should_populate_metadata=(args)
    @should_populate_metadata = args.present?
    return unless should_populate_metadata
    populate_metadata
    save
  end
end
