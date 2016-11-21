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
  def perform(message)
    file_set = ActiveFedora::Base.find(message['id'])
    uri = URI.parse(content_url(file_set))
    raise NotImplementedError, 'Only supports vector and raster file formats' if uri.path == ''
    raise NotImplementedError, 'Only supports file URLs' unless uri.scheme == 'file'
    GeoConcerns::DeliveryService.new(file_set, uri.path).publish
  end

  def content_url(file_set)
    case file_set.geo_mime_type
    when *GeoConcerns::RasterFormatService.select_options.map(&:last)
      return file_set.send(:derivative_url, 'display_raster')
    when *GeoConcerns::VectorFormatService.select_options.map(&:last)
      return file_set.send(:derivative_url, 'display_vector')
    else
      return ''
    end
  end
end
