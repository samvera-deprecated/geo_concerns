module GeoConcerns
  module Processors
    module Raster
      class Info
        attr_accessor :doc
        attr_writer :min_max, :size

        def initialize(path)
          @doc = gdalinfo(path)
        end

        # Returns the min and max values for a raster.
        # @return [String] computed min and max values
        def min_max
          @min_max ||= raster_min_max
        end

        # Returns the raster size.
        # @return [Array] raster size
        def size
          @size ||= raster_size
        end

        private

          # Runs the gdalinfo command and returns the result as a string.
          # @param path [String] path to raster file
          # @return [String] output of gdalinfo
          def gdalinfo(path)
            stdout, _stderr, _status = Open3.capture3("gdalinfo -mm #{path}")
            stdout
          end

          # Given an output string from the gdalinfo command, returns
          # a formatted string for the computed min and max values.
          # @return [String] computed min and max values
          def raster_min_max
            match = %r{(?<=Computed Min/Max=).*?(?=\s)}.match(doc)
            match ? match[0].tr(',', ' ') : ''
          end

          # Given an output string from the gdalinfo command, returns
          # an array containing the raster width and height as strings.
          # @return [String] raster size
          def raster_size
            match = /(?<=Size is ).*/.match(doc)
            match ? match[0].tr(',', '') : ''
          end
      end
    end
  end
end
