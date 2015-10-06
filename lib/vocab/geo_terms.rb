require 'rdf'
module Vocab
  class GeoTerms < RDF::Vocabulary('http://projecthydra.org/geoconcerns/models#')
    term :Geospatial
    term :Image
    term :Raster
    term :Vector
