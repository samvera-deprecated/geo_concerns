module GeoConcerns
  module Processors
    module Raster
      class Aig < GeoConcerns::Processors::Raster::Simple
        include GeoConcerns::Processors::Unzip

        def self.encode(path, options, output_file)
          unzip(path, output_file) do |zip_path|
            info = gdalinfo(zip_path)
            options[:min_max] = get_raster_min_max(info)
            encode_raster(zip_path, options, output_file)
          end
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
