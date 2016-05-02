module GeoConcerns
  # Attributes and methods for georeferenced files
  module GeoreferencedBehavior
    extend ActiveSupport::Concern

    included do
      # Defines the OGC coordinate reference system (CRS) identifier for the resource
      # @see http://www.opengeospatial.org/ogcna OGC Naming Authority
      # @example
      #   raster_file.cartographic_projection = "urn:ogc:def:crs:EPSG:6.3:26986"
      property :cartographic_projection,
               predicate: ::RDF::Vocab::Bibframe.cartographicProjection,
               multiple: false do |index|
        index.as :stored_searchable
      end
    end
  end
end
