module GeoConcerns
  module Processors
    module BaseGeoProcessor
      extend ActiveSupport::Concern

      included do
        # Returns a formatted gdal_rasterize command. Used to rasterize vector
        # format into raster format.
        #
        # @param in_path [String] file input path
        # #param options [Hash] creation options
        # @param out_path [String] processor output file path
        # @return [String] command for rasterizing vector dataset
        def self.rasterize(in_path, options, out_path)
          "gdal_rasterize -q -burn 0 -init 255 -ot Byte -ts "\
            "#{options[:output_size]} -of GTiff #{in_path} #{out_path}"
        end

        # Returns a formatted gdal_translate command. Used to translate a vector
        # format into a different format.
        #
        # @param in_path [String] file input path
        # #param options [Hash] creation options
        # @param out_path [String] processor output file path
        # @return [String] command for tranforming a vector dataset
        def self.translate(in_path, options, out_path)
          "gdal_translate -outsize #{options[:output_size]} -q -ot Byte "\
            "-of #{options[:output_format]} \"#{in_path}\" #{out_path}"
        end
      end

      def options_for(_format)
        {
          output_format: output_format,
          output_size: output_size
        }
      end

      # Tranforms the format directive into a GDAL output format.
      #
      # @output [Sting] Derivative output format.
      def output_format
        directives[:format] == 'jpg' ? 'JPEG' : directives[:format].upcase
      end

      # Tranforms the size directive into a GDAL size parameter.
      #
      # @output [String] Derivative size.
      def output_size
        directives[:size].tr('x', ' ')
      end
    end
  end
end
