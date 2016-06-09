module GeoConcerns
  class EventsGenerator
    class BaseEventsGenerator
      def initialize(messaging_client)
        @messaging_client = messaging_client
      end

      def message(type, record)
        base_message(type, record).merge({})
      end

      private

        def base_message(type, record)
          {
            "id" => record.id,
            "event" => type
          }
        end

        def publish_message(message)
          @messaging_client.publish(message.to_json)
        end

        def helper
          @helper ||= GeoConcerns::Discovery::DocumentBuilder::DocumentHelper.new
        end
    end
  end
end
