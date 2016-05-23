module GeoConcerns
  module GeoFileFormatBehavior
    extend ActiveSupport::Concern

    def image_file?
      ImageFormatService.include?(geo_mime_type)
    end

    def raster_file?
      RasterFormatService.include?(geo_mime_type)
    end

    def vector_file?
      VectorFormatService.include?(geo_mime_type)
    end

    def external_metadata_file?
      MetadataFormatService.include?(geo_mime_type)
    end

    def geo_file_format?
      image_file? || raster_file? || vector_file? || external_metadata_file?
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
  end
end
