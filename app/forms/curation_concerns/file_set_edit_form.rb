module CurationConcerns
  class FileSetEditForm < CurationConcerns::Forms::FileSetEditForm
    self.terms += [:conforms_to]
  end
end
