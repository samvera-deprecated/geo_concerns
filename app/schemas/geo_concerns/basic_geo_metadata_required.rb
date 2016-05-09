module GeoConcerns
  class BasicGeoMetadataRequired < ActiveTriples::Schema
    #
    # The following properties are inherited from Curation Concerns' metadata
    #
    # @see https://github.com/projecthydra-labs/curation_concerns/blob/master/curation_concerns-models/app/models/concerns/curation_concerns/required_metadata.rb
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

    # Defines the file format of the layer
    # @example
    #   image.format = 'TIFF'
    #   vector.format = 'Shapefile'
    #   raster.format = 'GeoTIFF'
    property :format, predicate: ::RDF::Vocab::DC11.format, multiple: false do |index|
      index.as :stored_searchable, :facetable
    end

    # Defines URL's to related services for the layer.
    # @example
    #   raster.references = { "http://www.opengis.net/def/serviceType/ogc/wms" => "https://geowebservices-restricted.stanford.edu/geoserver/wms" }
    #   vector.references = { "http://www.opengis.net/def/serviceType/ogc/wfs" => "https://geowebservices-restricted.stanford.edu/geoserver/wfs" }
    property :references, predicate: ::RDF::Vocab::DC.references, multiple: false do |index|
      index.as :stored_searchable, :facetable
    end
  end
end
