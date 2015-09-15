require 'rdf'
module GeoVocabularies
  class LayerTerms < RDF::StrictVocabulary("<ns here>")
    # Property definitions
    property :id,
      comment:
      domain:
      range:
      label:
      type: "rdf:Property".freeze
    property :geom_type,
      comment:
      domain:
      range:
      label:
      type: "rdf:Property".freeze
    property :modified,
      comment:
      domain:
      range:
      label:
      type: "rdf:Property".freeze
    property :slug,
      comment:
      domain:
      range:
      label:
      type: "rdf:Property".freeze
  end
end
