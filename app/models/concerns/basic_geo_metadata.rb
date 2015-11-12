# Attributes and methods for basic geospatial metadata
module BasicGeoMetadata
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
    # Defines the GeoRSS bounding box for the resource
    # From the spec: A bounding box is a rectangular region, often used to define the extents of a map
    # or a rough area of interest. A box contains two space seperate latitude-longitude pairs, with each
    # pair separated by whitespace. The first pair is the lower corner, the second is the upper corner.
    #
    # @see http://www.georss.org/simple.html GeoRSS Simple Specification
    # @example
    #   vector.bounding_box = "42.943 -71.032 43.039 -69.856"
    property :bounding_box, predicate: ::RDF::URI.new(PREFIXES[:georss] + 'box'), multiple: false do |index|
      index.as :stored_searchable
    end
  end
end
