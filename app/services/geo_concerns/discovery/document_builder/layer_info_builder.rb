module GeoConcerns
  module Discovery
    class DocumentBuilder
      class LayerInfoBuilder
        attr_reader :geo_concern

        def initialize(geo_concern)
          @geo_concern = geo_concern
        end

        # Builds fields about the geospatial file such as geometry and format.
        # @param [AbstractDocument] discovery document
        def build(document)
          document.geom_type = geom_type
          document.format = format
        end

        private

          # Uses parent work class to determine file geometry type.
          # These geom types are used in geoblacklight documents.
          # @return [String] file geometry type
          def geom_type
            case geo_concern.class.to_s
            when /ImageWorkShowPresenter/
              'Scanned Map'
            when /RasterWorkShowPresenter/
              'Raster'
            when /VectorWorkShowPresenter/
              vector_geom_type
            end
          end

          # Uses file mime type to determine file format.
          # @return [String] file format code
          def format
            if ImageFormatService.include? geo_mime_type
              ImageFormatService.code(geo_mime_type)
            elsif RasterFormatService.include? geo_mime_type
              RasterFormatService.code(geo_mime_type)
            elsif VectorFormatService.include? geo_mime_type
              VectorFormatService.code(geo_mime_type)
            end
          end

          # Returns the geometry for a vector file.
          # @return [String] vector geometry
          def vector_geom_type
            # TODO: Get the geom type as part of a geo characterization service.
            # "Point, Line, Polygon, Mixed"
            'Mixed'
          end

          # Returns the 'geo' mime type of the first file attached to the work.
          # @return [String] file mime type
          def geo_mime_type
            file_sets = geo_concern.geo_file_set_presenters
            return if file_sets.nil? || file_sets.empty?
            return unless (mime_types = file_sets.first.solr_document[:geo_mime_type_ssim])
            mime_types.first
          end
      end
    end
  end
end
