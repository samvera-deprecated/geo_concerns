class BasicGeoMetadataFileSet < ActiveTriples::Schema
  # Defines the essense of the layer, using GeoConcerns (GDAL/OGR) types
  # @example
  #   image.conforms_to = 'TIFF'
  #   vector.conforms_to = 'Shapefile'
  #   raster.conforms_to = 'GeoTIFF'
  #   metadata_file.conforms_to = 'FGDC'
  #   metadata_file.conforms_to = 'ISO19139'
  property :conforms_to, predicate: ::RDF::Vocab::DC.conformsTo, multiple: false do |index|
    index.as :stored_searchable, :facetable
  end
end
