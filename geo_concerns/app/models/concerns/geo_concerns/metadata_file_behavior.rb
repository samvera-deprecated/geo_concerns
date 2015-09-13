module GeoConcerns
  module MetadataFileBehavior
    extend ActiveSupport::Concern
    include Hydra::Works::GenericFileBehavior
    include ::CurationConcerns::GenericFileBehavior

    included do
      property :conforms_to, predicate: ::RDF::DC.conformsTo do |index|
        index.as :stored_searchable, :facetable
      end
    end

    # @return [Boolean] whether this instance is a GeoConcerns Metadata File.
    def concerns_metadata_file?
      true
    end
  end
end
