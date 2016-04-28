module GeoConcerns
  module Processors
    module Raster
      class Info
        attr_accessor :doc
        attr_writer :min_max, :size, :x, :y

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

        # Returns the raster width.
        # @return [Integer] raster width
        def width
          @x ||= size[0].to_i
        end

        # Returns the raster height.
        # @return [Integer] raster height
        def height
          @y ||= size[1].to_i
        end

        private

          # Runs the gdalinfo command and returns the result as a string.
          #
          # @param path [String] path to raster file
          # @return [String] output of gdalinfo
          def gdalinfo(path)
            stdout, _stderr, _status = Open3.capture3("gdalinfo -mm #{path}")
            stdout
          end

          # Given an output string from the gdalinfo command, returns
          # a formatted string for the computed min and max values.
          #
          # @return [String] computed min and max values
          def raster_min_max
            match = %r{(?<=Computed Min/Max=).*?(?=\s)}.match(doc)
            match ? match[0].tr(',', ' ') : ''
          end

          # Given an output string from the gdalinfo command, returns
          # an array containing the raster width and height as strings.
          #
          # @return [Array] raster szie array
          def raster_size
            match = /(?<=Size is ).*/.match(doc)
            match ? match[0].tr(' ', '').split(',') : ['0', '0']
          end
      end
    end
  end
end
