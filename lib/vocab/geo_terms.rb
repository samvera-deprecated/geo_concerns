require 'rdf'
module Vocab
  class GeoTerms < RDF::Vocabulary('http://projecthydra.org/geoconcerns/models#')
    term :Geospatial
    term :ImageWork
    term :RasterWork
    term :VectorWork
    term :ImageFile
    term :RasterFile
    term :VectorFile
    term :ExternalMetadataFile
  end
end
