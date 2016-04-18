module GeoConcerns
  module Processors
    module Raster
      class Base < Hydra::Derivatives::Processors::Processor
        include Hydra::Derivatives::Processors::ShellBasedProcessor
        include GeoConcerns::Processors::BaseGeoProcessor

        def self.encode(path, options, output_file)
          case options[:label]
          when :thumbnail
            encode_raster(path, options, output_file)
          when :display_raster
            reproject_raster(path, options, output_file)
          end
        end

        def self.encode_raster(in_path, options, out_path)
          execute translate(in_path, options, out_path)
          File.unlink("#{out_path}.aux.xml")
        end

        def self.reproject_raster(in_path, options, out_path)
          intermediate_file = intermediate_file_path(out_path)
          execute warp(in_path, options, intermediate_file)
          execute compress(intermediate_file, options, out_path)
          FileUtils.rm_rf(intermediate_file)
        end

        # Returns a formatted gdalwarp. Used to transform a raster
        # from one projection into another.
        #
        # @param in_path [String] file input path
        # #param options [Hash] creation options
        # @param out_path [String] processor output file path
        # @return [String] command for reprojecting a raster
        def self.warp(in_path, options, out_path)
          "gdalwarp -q -r bilinear -t_srs #{options[:output_srid]} "\
            " #{in_path} #{out_path} -co 'COMPRESS=NONE'"
        end

        # Returns a formatted gdal_translate command. Used compress
        # an previously uncompressed raster.
        #
        # @param in_path [String] file input path
        # #param options [Hash] creation options
        # @param out_path [String] processor output file path
        # @return [String] command for compressing a raster dataset
        def self.compress(in_path, options, out_path)
          "gdal_translate -q -ot Byte -a_srs #{options[:output_srid]} "\
            "\"#{in_path}\" #{out_path} -co 'COMPRESS=LZW'"
        end

        # Given an output string from the gdalinfo command, returns
        # a formatted string for the computed min and max values.
        #
        # @param info_string [String] ouput from gdalinfo
        # @return [String] computed min and max values
        def self.get_raster_min_max(info_string)
          match = %r{(?<=Computed Min/Max=).*?(?=\s)}.match(info_string)
          match ? match[0].tr(',', ' ') : ''
        end

        # Runs the gdalinfo command and returns the result as a string.
        #
        # @param path [String] path to raster file
        # @return [String] output of gdalinfo
        def self.gdalinfo(path)
          stdout, _stderr, _status = Open3.capture3("gdalinfo -mm #{path}")
          stdout
        end
      end
    end
  end
end
