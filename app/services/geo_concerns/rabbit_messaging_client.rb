require 'bunny'

module GeoConcerns
  class RabbitMessagingClient
    attr_reader :amqp_url
    def initialize(amqp_url)
      @amqp_url = amqp_url
    end

    def publish(message)
      exchange_type = JSON.parse(message)['exchange']
      send(exchange_type)
      @exchange.publish(message, persistent: true)
    rescue
      Rails.logger.warn "Unable to publish message to #{amqp_url}"
    end

    def geoblacklight
      exchange_name = Messaging.config['events']['exchange']['geoblacklight']
      @exchange ||= channel.fanout(exchange_name, durable: true)
    end

    def geoserver
      exchange_name = Messaging.config['events']['exchange']['geoserver']
      @exchange ||= channel.fanout(exchange_name, durable: true)
    end

    private

      def bunny_client
        @bunny_client ||= Bunny.new(amqp_url).tap(&:start)
      end

      def channel
        @channel ||= bunny_client.create_channel
      end
  end
end
