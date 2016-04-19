module GeoConcerns
  module Processors
    module Raster
      class Dem < GeoConcerns::Processors::Raster::Base
        def self.encode_raster(in_path, options, out_path)
          intermediate_file = intermediate_file_path(out_path)
          execute translate(in_path, options, intermediate_file)
          execute hillshade(intermediate_file, options, out_path)
          FileUtils.rm_rf(intermediate_file)
          File.unlink("#{out_path}.aux.xml")
        end

        def self.reproject_raster(in_path, options, out_path)
          intermediate_file = intermediate_file_path(out_path)
          execute hillshade(in_path, options, intermediate_file)
          execute warp(intermediate_file, options, out_path)
          FileUtils.rm_rf(intermediate_file)
        end

        # Returns a formatted gdal_translate command to translate a vector
        # in USGS DEM format into a different format.
        #
        # @param in_path [String] file input path
        # #param options [Hash] creation options
        # @param out_path [String] processor output file path
        # @return [String] command for tranforming a usgs dem dataset
        def self.translate(in_path, options, out_path)
          "gdal_translate -outsize #{options[:output_size]} -q -ot Byte "\
            "-of USGSDEM #{in_path} #{out_path}"
        end

        # Returns a formatted gdal hillshade command. Calculates hillshade
        # on a raster that contains elevation data.
        #
        # @param in_path [String] file input path
        # #param options [Hash] creation options
        # @param output_file [String] processor output file path
        # @return [String] command for generating a hillshade
        def self.hillshade(in_path, options, out_path)
          "gdaldem hillshade -q "\
            "-of #{options[:output_format]} \"#{in_path}\" #{out_path}"
        end
      end
    end
  end
end
