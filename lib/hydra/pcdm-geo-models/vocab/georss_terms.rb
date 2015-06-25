require 'rdf'
module GeoVocabularies
  class GeoRSSTerms < RDF::StrictVocabulary("http://www.w3.org/2003/01/geo/wgs84_pos#")
    # Property definitions
    property :box,
      comment:
      domain:
      range:
      label:
      type: "rdf:Property".freeze
    property :point,
      comment:
      domain:
      range:
      label:
      type: "rdf:Property".freeze
    property :polygon,
      comment:
      domain:
      range:
      label:
      type: "rdf:Property".freeze
  end
end
