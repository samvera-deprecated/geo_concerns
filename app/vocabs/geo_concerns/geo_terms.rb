require 'rdf'
module GeoConcerns
  class GeoTerms < RDF::Vocabulary('http://projecthydra.org/geoconcerns/models#')
    term :ImageWork
    term :RasterWork
    term :VectorWork
    term :ImageFile
    term :RasterFile
    term :VectorFile
    term :ExternalMetadataFile
  end
end
