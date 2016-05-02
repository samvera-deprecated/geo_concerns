module GeoConcerns
  class RasterWorkShowPresenter < GeoConcernsShowPresenter
    def vector_work_presenters
      # filter for vector works
      members(::GeoConcerns::VectorWorkShowPresenter).select do |member|
        format = member.solr_document[:has_model_ssim]
        format ? format.first == 'VectorWork' : false
      end
    end

    def raster_file_presenters
      # filter for raster files
      members(::FileSetPresenter).select do |member|
        RasterFormatService.include? member.solr_document[:mime_type_ssi]
      end
    end
  end
end
