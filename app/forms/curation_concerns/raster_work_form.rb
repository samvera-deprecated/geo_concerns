module CurationConcerns
  class RasterWorkForm < CurationConcerns::Forms::WorkForm
    include ::GeoConcerns::BasicGeoMetadataForm
    include ::GeoConcerns::GeoreferencedForm
    include ::GeoConcerns::ExternalMetadataFileForm
    self.model_class = ::RasterWork
  end
end
