require 'rdf'
module GeoVocabularies
  class GeoTerms < RDF::Vocabulary("http://hydra.org/geo/models#")

    # Class definitions
    term :Image
    term :Raster
    term :Vector

  end
end
