# A georeferenced map that been warped or Raster work like GeoTIFF
class Raster < ActiveFedora::Base
  include ::GeoConcerns::RasterBehavior
  validates_presence_of :title,  message: 'Your work must have a title.'
  validates_presence_of :georss_box,  message: 'Your work must have a bbox.'
end
