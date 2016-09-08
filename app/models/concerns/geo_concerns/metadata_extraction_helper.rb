module GeoConcerns
  module MetadataExtractionHelper
    # Extracts properties from the constitutent external metadata file
    # @return [Hash]
    def extract_metadata(id)
      return {} if metadata_files.blank?
      metadata_files.each do |metadata_file|
        return metadata_file.extract_metadata if metadata_file.id == id
      end
    end

    # Sets properties from the constitutent external metadata file
    def populate_metadata(id)
      extract_metadata(id).each do |k, v|
        send("#{k}=".to_sym, v) # set each property
      end
    end

    attr_accessor :should_populate_metadata

    def should_populate_metadata=(args)
      @should_populate_metadata = args.present?
      return unless should_populate_metadata
      populate_metadata(args)
      save
    end
  end
end
