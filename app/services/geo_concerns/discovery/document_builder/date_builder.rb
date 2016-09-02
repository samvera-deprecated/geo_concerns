module GeoConcerns
  module Discovery
    class DocumentBuilder
      class DateBuilder
        attr_reader :geo_concern

        def initialize(geo_concern)
          @geo_concern = geo_concern
        end

        # Builds date fields such as layer year and modified date.
        # @param [AbstractDocument] discovery document
        def build(document)
          document.layer_year = layer_year
          document.layer_modified = layer_modified
          document.issued = issued
        end

        private

          # Returns a year associated with the layer. Taken from first
          # value in temporal.
          # @return [Integer] year
          def layer_year
            date = geo_concern.temporal.first
            year = date.match(/(?<=\D|^)(\d{4})(?=\D|$)/)
            year ? year[0].to_i : nil
          end

          # Returns the date the work was modified.
          # @return [String] date in XMLSchema format.
          def layer_modified
            geo_concern.layer_modified.try(:xmlschema)
          end

          # Returns the date the layer was issued.
          # @return [String] date in XMLSchema format.
          def issued
            datetime = geo_concern.issued.first
            datetime = DateTime.parse(datetime.to_s).utc
            # TODO: Rails 4 doesn't implement the timezone correctly -- it adds "+00:00" not "Z"
            Rails::VERSION::MAJOR == 4 ? datetime.utc.strftime('%FT%TZ') : datetime.utc.xmlschema
          rescue
            ''
          end
      end
    end
  end
end
