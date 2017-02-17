module GeoConcerns
  class ImageWorkShowPresenter < GeoConcernsShowPresenter
    self.file_format_service = ImageFormatService
  end
end
