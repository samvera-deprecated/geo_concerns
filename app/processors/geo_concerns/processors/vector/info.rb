module GeoConcerns
  module Processors
    module Vector
      class Info
        attr_accessor :doc
        attr_writer :name, :driver

        def initialize(path)
          @doc = ogrinfo(path)
        end

        # Returns the vector dataset name
        # @return [String] dataset name
        def name
          @name = vector_name
        end

        # Returns the ogr driver name
        # @return [String] driver name
        def driver
          @driver = driver_name
        end

        # Returns vector geometry type
        # @return [String] geom
        def geom
          @geom = vector_geom
        end

        private

          # Runs the ogrinfo command and returns the result as a string.
          # @param path [String] path to vector file or shapefile directory
          # @return [String] output of ogrinfo
          def ogrinfo(path)
            stdout, _stderr, _status = Open3.capture3("ogrinfo #{path}")
            stdout
          end

          # Given an output string from the ogrinfo command, returns
          # the vector dataset name.
          # @return [String] vector dataset name
          def vector_name
            match = /(?<=\d:\s).*?((?=\s)|($))/.match(doc)
            match ? match[0] : ''
          end

          # Given an output string from the ogrinfo command, returns
          # the ogr driver used to read dataset.
          # @return [String] ogr driver name
          def driver_name
            match = /(?<=driver\s`).*?(?=')/.match(doc)
            match ? match[0] : ''
          end

          # Given an output string from the ogrinfo command, returns
          # the vector geometry type.
          # @return [String] vector geom
          def vector_geom
            match = /(?<=\().*?(?=\))/.match(doc)
            match ? match[0] : ''
          end
      end
    end
  end
end
