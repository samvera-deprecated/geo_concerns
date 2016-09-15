module GeoConcerns
  class BasicGeoMetadataRequired < ActiveTriples::Schema
    #
    # The following properties are inherited from Curation Concerns' metadata
    #
    # @see https://github.com/projecthydra/curation_concerns/blob/v1.6.0/app/models/concerns/curation_concerns/required_metadata.rb
    # Required:
    #   :title
    #   :date_uploaded (DC.dateSubmitted)
    #   :date_modified (DC.modified)
    #

    # Defines the bounding box for the layer.
    # We always assert units of decimal degrees and EPSG:4326 projection.
    # @see http://dublincore.org/documents/dcmi-box/
    # @example
    #   vector.coverage = 'northlimit=43.039; eastlimit=-69.856; southlimit=42.943; westlimit=-71.032; units=degrees; projection=EPSG:4326'
    property :coverage, predicate: ::RDF::Vocab::DC11.coverage, multiple: false

    # Defines the institution which holds the layer
    # @example
    #   raster.provenance = 'Stanford University'
    property :provenance, predicate: ::RDF::Vocab::DC.provenance, multiple: false
  end
end
