module GeoFileFormatBehavior
  extend ActiveSupport::Concern

  def image_file?
    ImageFormatService.include?(mime_type)
  end

  def raster_file?
    RasterFormatService.include?(mime_type)
  end

  def vector_file?
    VectorFormatService.include?(mime_type)
  end

  def external_metadata_file?
    MetadataFormatService.include?(mime_type)
  end

  def image_work?
    false
  end

  def raster_work?
    false
  end

  def vector_work?
    false
  end

  module ClassMethods
    def gdal_formats
      [
        'image/tiff; gdal-format=GTiff',
        'text/plain; gdal-format=AIGrid'
      ].freeze
    end

    def ogr_formats
      [
        'application/zip; ogr-format="ESRI Shapefile"',
        'application/zip; ogr-format=OpenFileGDB',
        'application/octet-stream; ogr-format=MDB'
      ].freeze
    end

    def metadata_standards
      %w(FGDC ISO19139 MODS).freeze
    end
  end
end
