module GeoConcerns
  class FileSetEditForm < GeoConcerns::Forms::FileSetEditForm
    self.terms += [:geo_mime_type]
  end
end
