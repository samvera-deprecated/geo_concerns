module GeoConcerns
  class RasterWorkShowPresenter < GeoConcernsShowPresenter
    self.file_format_service = GeoConcerns::RasterFormatService
  end
end
