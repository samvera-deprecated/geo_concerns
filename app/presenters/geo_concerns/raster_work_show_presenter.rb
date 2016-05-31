module GeoConcerns
  class RasterWorkShowPresenter < GeoConcernsShowPresenter
    self.work_presenter_class = ::GeoConcerns::VectorWorkShowPresenter
    self.file_format_service = GeoConcerns::RasterFormatService
  end
end
