module GeoConcerns
  class VectorWorkForm < CurationConcerns::Forms::WorkForm
    include ::GeoConcerns::BasicGeoMetadataForm
    include ::GeoConcerns::GeoreferencedForm
    include ::GeoConcerns::ExternalMetadataFileForm
    self.model_class = ::VectorWork
  end
end
