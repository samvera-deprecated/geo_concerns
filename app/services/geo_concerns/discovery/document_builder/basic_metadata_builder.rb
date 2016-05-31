module GeoConcerns
  module Discovery
    class DocumentBuilder
      class BasicMetadataBuilder
        attr_reader :geo_concern

        def initialize(geo_concern)
          @geo_concern = geo_concern
        end

        # Builds fields such as id, subject, and publisher.
        # @param [AbstractDocument] discovery document
        def build(document)
          build_simple_attributes(document)
          build_complex_attributes(document)
        end

        private

          # Returns an array of attributes to add to document.
          # @return [Array] attributes
          def simple_attributes
            [:id, :creator, :subject, :spatial, :temporal,
             :title, :provenance, :language, :publisher]
          end

          # Builds simple metadata attributes.
          # @param [AbstractDocument] discovery document
          def build_simple_attributes(document)
            simple_attributes.each do |a|
              document.send("#{a}=", geo_concern.send(a.to_s))
            end
          end

          # Builds more complex metadata attributes.
          # @param [AbstractDocument] discovery document
          def build_complex_attributes(document)
            document.identifier = identifier
            document.description = description
            document.access_rights = geo_concern.solr_document.visibility
            document.slug = slug
          end

          # Returns the work description. If none is available,
          # a basic description is created.
          # @return [String] description
          def description
            return geo_concern.description.first if geo_concern.description.first
            "A #{geo_concern.human_readable_type.downcase} object."
          end

          # Returns the document slug for use in discovery systems.
          # @return [String] document slug
          def slug
            return unless geo_concern.provenance
            "#{geo_concern.provenance[0].downcase.tr(' ', '-')}-#{geo_concern.id}"
          end

          # Returns the document identifier. If there is no identifier,
          # the work id is used instead.
          # @return [String] document identifier
          def identifier
            field = geo_concern.solr_document[:identifier_tesim]
            field ? field.first : geo_concern.id
          end
      end
    end
  end
end
