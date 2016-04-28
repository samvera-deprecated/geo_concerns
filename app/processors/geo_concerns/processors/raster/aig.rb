module GeoConcerns
  module Processors
    module Raster
      class Aig < GeoConcerns::Processors::Raster::Base
        include GeoConcerns::Processors::Zip

        def self.encode(path, options, output_file)
          unzip(path, output_file) do |zip_path|
            info = Info.new(zip_path)
            options[:min_max] = info.min_max
            case options[:label]
            when :thumbnail
              encode_raster(zip_path, options, output_file)
            when :display_raster
              reproject_raster(zip_path, options, output_file)
            end
          end
        end

        def self.reproject_raster(in_path, options, out_path)
          options[:output_size] = '100% 100%'
          intermediate_file = intermediate_file_path(out_path)
          execute warp(in_path, options, intermediate_file)
          execute translate(intermediate_file, options, out_path)
          FileUtils.rm_rf(intermediate_file)
        end

        # Returns a formatted gdal_translate command to translate a raster
        # format into a different format with a scaling options. This command
        # scales the min and max values of the raster into the 0 to 255 range.
        # Scale is inverted (255 to 0) to create a better visualization.
        #
        # @param in_path [String] file input path
        # #param options [Hash] creation options
        # @param out_path [String] processor output file path
        # @return [String] command for tranforming a usgs dem dataset
        def self.translate(in_path, options, out_path)
          "gdal_translate -scale #{options[:min_max]} 255 0 -outsize #{options[:output_size]} "\
             "-q -ot Byte -of #{options[:output_format]} \"#{in_path}\" #{out_path}"
        end
      end
    end
  end
end
