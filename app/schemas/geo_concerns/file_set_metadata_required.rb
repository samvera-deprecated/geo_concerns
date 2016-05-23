module GeoConcerns
  class FileSetMetadataRequired < ActiveTriples::Schema
    property :geo_mime_type, predicate: RDF::Vocab::EBUCore.hasMimeType, multiple: false
  end
end
