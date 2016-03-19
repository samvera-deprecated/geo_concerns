module CurationConcerns
  class VectorWorkForm < CurationConcerns::Forms::WorkForm
    include BasicGeoMetadataForm
    include GeoreferencedForm
    include ExternalMetadataFileForm
    self.model_class = ::VectorWork
  end
end
