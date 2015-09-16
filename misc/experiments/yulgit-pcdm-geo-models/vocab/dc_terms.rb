require 'rdf'
module GeoVocabularies
  class DublinCoreTerms < RDF::StrictVocabulary("http://purl.org/dc/terms/")
    # Property definitions
    property :provenance,
      comment:
      domain:
      range:
      label:
      type: "rdf:Property".freeze
    property :references,
      comment:
      domain:
      range:
      label:
      type: "rdf:Property".freeze
    property :spatial,
      comment:
      domain:
      range:
      label:
      type: "rdf:Property".freeze
    property :temporal,
      comment:
      domain:
      range:
      label:
      type: "rdf:Property".freeze
    property :issued,
      comment:
      domain:
      range:
      label:
      type: "rdf:Property".freeze
    property :isPartOf,
      comment:
      domain:
      range:
      label:
      type: "rdf:Property".freeze
  end
end      
