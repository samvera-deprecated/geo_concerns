# Attributes and methods for external metadata files
module MetadataFileBehavior
  extend ActiveSupport::Concern
  include Hydra::Works::FileSetBehavior
  include ::CurationConcerns::FileSetBehavior

  included do
    # Specifies the metadata standard to which the metadata file conforms
    # @see http://dublincore.org/documents/dcmi-terms/#terms-conformsTo
    property :conforms_to, predicate: ::RDF::DC.conformsTo do |index|
      index.as :stored_searchable, :facetable
    end
  end

  # Inspects whether or not this Object is a Metadata File
  # @return [Boolean]
  def concerns_metadata_file?
    true
  end
end
