class BasicGeoMetadataFileSet < ActiveTriples::Schema
  # Defines the standard for metadata files
  # @example
  #   metadata_file.conforms_to = 'FGDC'
  #   metadata_file.conforms_to = 'ISO19139'
  #   metadata_file.conforms_to = 'MODS'
  property :conforms_to, predicate: ::RDF::Vocab::DC.conformsTo, multiple: false do |index|
    index.as :stored_searchable, :facetable
  end
end
