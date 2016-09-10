require 'uri'

##
# Delivers derivatives to external services, like GeoServer
##
class DeliveryJob < ActiveJob::Base
  queue_as CurationConcerns.config.ingest_queue_name

  ##
  # Precondition is that all derivatives are created and saved.
  # @param [FileSet] file_set
  # @param [String] content_url contains the display copy to deliver
  def perform(file_set, content_url)
    uri = URI.parse(content_url)
    raise NotImplementedError, 'Only supports file URLs' unless uri.scheme == 'file'
    GeoConcerns::DeliveryService.new.publish(file_set.id, uri.path)
  end
end
