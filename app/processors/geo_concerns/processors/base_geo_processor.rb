module GeoConcerns
  module Processors
    module BaseGeoProcessor
      extend ActiveSupport::Concern

      included do
        # Returns a formatted gdal_translate command. Used to translate a raster
        # format into a different format. Also used in generating thumbnails
        # from vector data.
        #
        # @param in_path [String] file input path
        # #param options [Hash] creation options
        # @param out_path [String] processor output file path
        # @return [String] command for transforming a raster dataset
        def self.translate(in_path, options, out_path)
          "gdal_translate -outsize #{options[:output_size]} -q -ot Byte "\
            "-of #{options[:output_format]} \"#{in_path}\" #{out_path}"
        end

        # Returns a path to an intermediate temp file.
        #
        # @param path [String] input file path to base temp path on
        # @return [String] tempfile path
        def self.intermediate_file_path(path)
          ext = File.extname(path)
          "#{File.dirname(path)}/#{File.basename(path, ext)}_temp#{ext}"
        end
      end

      def options_for(_format)
        {
          label: label,
          output_format: output_format,
          output_size: output_size,
          output_srid: output_srid,
          basename: basename
        }
      end

      # Returns the label directive or an empty string.
      #
      # @return [Sting] output label
      def label
        directives.fetch(:label, '')
      end

      # Tranforms the format directive into a GDAL output format.
      #
      # @return [Sting] derivative output format
      def output_format
        format = directives.fetch(:format, '').upcase
        case format
        when 'JPG'
          'JPEG'
        when 'TIF'
          'GTiff'
        else
          format
        end
      end

      # Tranforms the size directive into a GDAL size parameter.
      #
      # @return [String] derivative size
      def output_size
        return unless directives[:size]
        directives[:size].tr('x', ' ')
      end

      # Gets srid for reprojection derivative or returns WGS 84.
      #
      # @return [String] spatial reference code
      def output_srid
        directives.fetch(:srid, 'EPSG:4326')
        # directives[:srid] ? directives[:srid] : 'EPSG:4326'
      end

      # Extracts the base file name (without extension) from the source file path.
      #
      # @return [String] base file name for source
      def basename
        File.basename(source_path, File.extname(source_path))
      end
    end
  end
end
