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
          document.date_modified = date_modified
        end

        private

          # Returns a year associated with the layer. Taken from first
          # value in temporal or from date uploaded. If neither is valid,
          # the current year is used.
          # @return [Integer] year
          def layer_year
            date = geo_concern.temporal.first || geo_concern.date_uploaded
            year = date.match(/(?<=\D|^)(\d{4})(?=\D|$)/)
            year ? year[0].to_i : Time.current.year
          end

          # Returns the date the work was modified.
          # @return [String] date in rfc3339 format.
          def date_modified
            DateTime.rfc3339(geo_concern.solr_document[:date_modified_dtsi]).to_s
          end
      end
    end
  end
end
