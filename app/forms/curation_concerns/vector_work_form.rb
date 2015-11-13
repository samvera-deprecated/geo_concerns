module CurationConcerns
  class VectorWorkForm < CurationConcerns::Forms::WorkForm
    include BasicGeoMetadataForm
    include GeoreferencedForm
    self.model_class = ::VectorWork
  end
end
