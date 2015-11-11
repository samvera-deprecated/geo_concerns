# Attributes and methods for basic geospatial metadata
module BasicGeoWorksMetadata
  extend ActiveSupport::Concern

  # Namespace prefixes for the RDF predicates
  PREFIXES = {
    csw: 'http://www.opengis.net/def/serviceType/ogc/csw/2.0.2#',
    dc: 'http://purl.org/dc/terms/',
    georss: 'http://www.georss.org/georss/',
    ogc: 'http://www.opengis.net/def/dataType/OGC/1.1/',
    ore: 'http://www.openarchives.org/ore/terms/',
    pcdm: 'http://pcdm.org/models#'
  }

  included do
    # Defines the GeoRSS bounding box for the resource, must be in WGS84
    # @see http://www.georss.org/simple.html GeoRSS Simple Specification
    # @example
    #   vector.bbox = "42.943 -71.032 43.039 -69.856"
    property :bounding_box, predicate: ::RDF::URI.new(PREFIXES[:georss] + 'box'), multiple: false do |index|
      index.as :stored_searchable
    end
  end
end
