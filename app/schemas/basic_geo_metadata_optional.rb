class BasicGeoMetadataOptional < ActiveTriples::Schema
  #
  # The following properties are inherited from Curation Concerns' metadata
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
    index.type :date
    index.as :stored_searchable
  end

  # Defines the format of the resource
  # @example
  #   image.format = 'GeoTIFF'
  #   raster.format = 'ArcGRID'
  #   vector.format = 'Shapefile'
  property :format, predicate: ::RDF::Vocab::DC11.format, multiple: false do |index|
    index.as :stored_searchable, :facetable
  end
end
