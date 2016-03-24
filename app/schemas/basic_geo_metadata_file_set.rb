class BasicGeoMetadataFileSet < ActiveTriples::Schema
  # Defines the semantics (standard) of the metadata file
  # @example
  #   metadata_file.conforms_to = 'FGDC'
  #   metadata_file.conforms_to = 'ISO19139'
  property :conforms_to, predicate: ::RDF::Vocab::DC.conformsTo, multiple: false do |index|
    index.as :stored_searchable, :facetable
  end
end
