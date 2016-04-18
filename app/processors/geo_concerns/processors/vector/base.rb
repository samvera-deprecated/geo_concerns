module GeoConcerns
  module Processors
    module Vector
      class Base < Hydra::Derivatives::Processors::Processor
        include Hydra::Derivatives::Processors::ShellBasedProcessor
        include GeoConcerns::Processors::BaseGeoProcessor
        include GeoConcerns::Processors::Zip

        def self.encode(path, options, output_file)
          case options[:label]
          when :thumbnail
            encode_vector(path, options, output_file)
          when :display_vector
            reproject_vector(path, options, output_file)
          end
        end

        def self.encode_vector(in_path, options, out_path)
          tiff_path = "#{File.dirname(in_path)}/out.tif"
          execute rasterize(in_path, options, tiff_path)
          execute translate(tiff_path, options, out_path)
          File.unlink(tiff_path)
          File.unlink("#{out_path}.aux.xml")
        end

        def self.reproject_vector(in_path, options, out_path)
          shapefile_path = intermediate_shapefile_path(out_path)
          execute reproject(in_path, options, shapefile_path)
          zip(shapefile_path, out_path)
          FileUtils.rm_rf(shapefile_path)
        end

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

        # Returns a formatted ogr2ogr command. Used to reproject a
        # vector dataset and save the output as a shapefile.
        #
        # @param in_path [String] file input path
        # #param options [Hash] creation options
        # @param out_path [String] processor output file path
        # @return [String] command for reprojecting vector data
        def self.reproject(in_path, options, out_path)
          "env SHAPE_ENCODING= ogr2ogr -q -nln #{options[:basename]} "\
            "-f 'ESRI Shapefile' -t_srs #{options[:output_srid]} '#{out_path}' '#{in_path}'"
        end

        # Returns a path to an intermediate shape file directory.
        #
        # @param path [String] file path to base temp path on
        # @return [String] tempfile path
        def self.intermediate_shapefile_path(path)
          ext = File.extname(path)
          "#{File.dirname(path)}/#{File.basename(path, ext)}/"
        end
      end
    end
  end
end
