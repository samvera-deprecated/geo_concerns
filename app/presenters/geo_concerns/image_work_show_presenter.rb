module GeoConcerns
  class ImageWorkShowPresenter < GeoConcernsShowPresenter
    self.work_presenter_class = ::GeoConcerns::RasterWorkShowPresenter
    self.file_format_service = ImageFormatService
  end
end
