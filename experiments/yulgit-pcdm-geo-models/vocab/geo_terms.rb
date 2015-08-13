require 'rdf'
module GeoVocabularies
  class GeoTerms < RDF::Vocabulary("http://hydra.org/geo/models#")

    # Class definitions
    term :ScannedImage
    term :GeorectifiedImage
    term :Vector
    term :FeatureExtraction

  end
end
