module GeoConcerns
  class LocalMessagingClient
    def publish(message)
      processor = JSON.parse(message)['exchange']
      send(processor, JSON.parse(message))
    rescue
      Rails.logger.warn "Unable to publish message with the local message client"
    end

    def geoblacklight(message)
      GeoblacklightJob.perform_later(message)
    end
  end
end
