module BasicGeoMetadata
  extend ActiveSupport::Concern

  included do

    # Example value: ENVELOPE(-179.14734, 179.778465, 71.390482, 17.881242)
    # See http://portal.opengeospatial.org/files/?artifact_id=20555
    property :solr_geom, predicate: ::RDF::URI.new("http://www.opengis.net/def/serviceType/ogc/csw/2.0.2#envelope"), multiple: false do |index|
      
      # Solrizer needs to be configured to use location_rpt; not working here.
      index.as Solrizer::Descriptor.new(:location_rpt, :stored, :indexed)
    end

    # Alternate or additional bbox
    property :georss_box, predicate: ::RDF::URI.new("http://www.georss.org/georss/box"), multiple: false do |index|
      index.as :stored_searchable
    end
    
    # Example values
    #   urn:ogc:def:crs:EPSG::3163
    #   urn:ogc:def:crs,crs:EPSG::4269,crs:EPSG::5713
    #   http://www.opengis.net/def/crs/epsg/0/3163 (maybe? referred to in WFS query document)
    # See http://portal.opengeospatial.org/files/?artifact_id=30575
    property :crs, predicate: ::RDF::URI.new("http://www.opengis.net/def/dataType/OGC/1.1/crsURI"), multiple: false do |index|
      index.as :stored_searchable
    end
  end
end
