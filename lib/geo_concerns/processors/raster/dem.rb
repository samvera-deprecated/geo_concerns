module GeoConcerns
  module Processors
    module Raster
      class Dem < GeoConcerns::Processors::Raster::Simple
        def self.encode_raster(in_path, options, out_path)
          resized_dem_path = resized_out_path(out_path)
          execute translate(in_path, options, resized_dem_path)
          execute hillshade(resized_dem_path, options, out_path)
          FileUtils.rm_rf(resized_dem_path)
          File.unlink("#{out_path}.aux.xml")
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

        # Returns a path to the resized intermediate file.
        #
        # @param path [String] resized raster intermediate file
        # @return [String] command for generating a hillshade
        def self.resized_out_path(path)
          ext = File.extname(path)
          "#{File.dirname(path)}/#{File.basename(path, ext)}_resize#{ext}"
        end
      end
    end
  end
end
