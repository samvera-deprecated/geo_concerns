require 'rdf'
module Vocab
  # Integration with the rdf-vocab Gem (https://github.com/ruby-rdf/rdf-vocab) is currently being explored
  class GeoRssTerms < RDF::Vocabulary('http://www.georss.org/georss/')
    term :Box
  end
end
