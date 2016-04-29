module GeoConcerns
  module Processors
    module Gdal
      extend ActiveSupport::Concern

      included do
        # Executes a gdal_translate command. Used to translate a raster
        # format into a different format. Also used in generating thumbnails
        # from vector data.
        # @param in_path [String] file input path
        # @param out_path [String] processor output file path
        # @param options [Hash] creation options
        def self.translate(in_path, out_path, _options)
          execute "gdal_translate -q -ot Byte -of GTiff \"#{in_path}\" #{out_path}"
        end

        # Executes a gdalwarp command. Used to transform a raster
        # from one projection into another.
        # @param in_path [String] file input path
        # @param out_path [String] processor output file path
        # @param options [Hash] creation options
        def self.warp(in_path, out_path, options)
          execute "gdalwarp -q -r bilinear -t_srs #{options[:output_srid]} "\
                  "#{in_path} #{out_path} -co 'COMPRESS=NONE'"
        end

        # Executes a gdal_translate command. Used to compress
        # a previously uncompressed raster.
        # @param in_path [String] file input path
        # @param out_path [String] processor output file path
        # @param options [Hash] creation options
        def self.compress(in_path, out_path, options)
          execute "gdal_translate -q -ot Byte -a_srs #{options[:output_srid]} "\
                    "#{in_path} #{out_path} -co 'COMPRESS=LZW'"
        end

        # Executes a gdal_rasterize command. Used to rasterize vector
        # format into raster format.
        # @param in_path [String] file input path
        # #param options [Hash] creation options
        # @param out_path [String] processor output file path
        def self.rasterize(in_path, out_path, options)
          execute "gdal_rasterize -q -burn 0 -init 255 -ot Byte -ts "\
                    "#{options[:output_size]} -of GTiff #{in_path} #{out_path}"
        end
      end
    end
  end
end
