module GeoConcerns
  module FileSetActionsHelper
    def file_set_actions(presenter, locals = {})
      render file_set_actions_partial(presenter),
             locals.merge(file_set: presenter)
    end

    def file_set_actions_partial(file_set)
      format = file_set_actions_format(file_set)
      'geo_concerns/file_sets/actions/' +
        if format
          format
        else
          'default_actions'
        end
    end

    def file_set_actions_format(file_set)
      geo_mime_type = file_set.solr_document.fetch(:geo_mime_type_ssim, []).first
      if GeoConcerns::ImageFormatService.include?(geo_mime_type)
        'image_actions'
      elsif GeoConcerns::VectorFormatService.include?(geo_mime_type)
        'vector_actions'
      elsif GeoConcerns::RasterFormatService.include?(geo_mime_type)
        'raster_actions'
      elsif GeoConcerns::MetadataFormatService.include?(geo_mime_type)
        'metadata_actions'
      end
    end
  end
end
