module GeoConcerns
  class EventsGenerator
    class GeoblacklightEventGenerator < BaseEventsGenerator
      def record_created(record)
        publish_message(
          message("CREATED", record)
        )
      end

      def record_deleted(record)
        publish_message(
          delete_message("DELETED", record)
        )
      end

      def record_updated(record)
        publish_message(
          message("UPDATED", record)
        )
      end

      def message(type, record)
        base_message(type, record).merge("exchange" => :geoblacklight,
                                         "doc" => generate_document(record))
      end

      def delete_message(type, record)
        base_message(type, record).merge("exchange" => :geoblacklight,
                                         "id" => slug(record))
      end

      private

        def generate_document(record)
          Discovery::DocumentBuilder.new(record, Discovery::GeoblacklightDocument.new)
        end

        def slug(record)
          return record.id unless record.respond_to?(:provenance)
          "#{record.provenance.parameterize}-#{record.id}"
        end
    end
  end
end
