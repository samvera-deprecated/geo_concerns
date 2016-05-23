module GeoConcerns
  class VectorWorkShowPresenter < GeoConcernsShowPresenter
    self.file_format_service = VectorFormatService
  end
end
