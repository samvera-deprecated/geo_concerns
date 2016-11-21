require 'uri'

# Loads geoblacklight
class GeoblacklightJob < ActiveJob::Base
  queue_as :default

  def perform(message)
    GeoblacklightMessaging::GeoblacklightEventProcessor.new(message).process
  end
end
