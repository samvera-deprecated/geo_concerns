# A georeferenced map that been warped or Raster work like GeoTIFF
class Raster < ActiveFedora::Base
  include ::GeoConcerns::RasterBehavior
end
