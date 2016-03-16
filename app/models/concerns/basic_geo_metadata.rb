# Attributes and methods for basic geospatial metadata used by Works
module BasicGeoMetadata
  extend ActiveSupport::Concern

  included do
    #
    # The following properties are inherited from Curation Concerns' metadata
    #
    # @see https://github.com/projecthydra-labs/curation_concerns/blob/master/curation_concerns-models/app/models/concerns/curation_concerns/required_metadata.rb
    # Required:
    #   :title
    #   :date_uploaded (DC.dateSubmitted)
    #   :date_modified (DC.modified)
    #
    # @see https://github.com/projecthydra-labs/curation_concerns/blob/master/curation_concerns-models/app/models/concerns/curation_concerns/basic_metadata.rb
    # Optional:
    #   :contributor
    #   :creator
    #   :date_created (DC.created)
    #   :description
    #   :identifier
    #   :language
    #   :part_of
    #   :publisher
    #   :resource_type (DC.type)
    #   :rights
    #   :source
    #   :subject
    #   :tag (DC11.relation)
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
    property :provenance, predicate: ::RDF::Vocab::DC.provenance, multiple: false do |index|
      index.as :stored_searchable, :facetable
    end

    # Defines the file format of the layer
    # @example
    #   image.format = 'TIFF'
    #   vector.format = 'Shapefile'
    #   raster.format = 'GeoTIFF'
    property :format, predicate: ::RDF::Vocab::DC11.format, multiple: false do |index|
      index.as :stored_searchable, :facetable
    end

    # Defines the placenames related to the layer
    # @example
    #   image.spatial = [ 'France', 'Spain' ]
    property :spatial, predicate: ::RDF::Vocab::DC.spatial do |index|
      index.as :stored_searchable, :facetable
    end

    # Defines the temporal coverage of the layer
    # @example
    #   vector.temporal = [ '1998-2006', 'circa 2000' ]
    property :temporal, predicate: ::RDF::Vocab::DC.temporal do |index|
      index.as :stored_searchable, :facetable
    end

    # Defines the issued date for the layer, using XML Schema dateTime format (YYYY-MM-DDThh:mm:ssZ).
    # @example
    #   vector.issued = '2001-01-01T00:00:00Z'
    property :issued, predicate: ::RDF::Vocab::DC.issued, multiple: false do |index|
      index.as :stored_searchable
    end
  end
end
