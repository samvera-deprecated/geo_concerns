module CurationConcerns
  class RasterWorkForm < CurationConcerns::Forms::WorkForm
    include BasicGeoMetadataForm
    include GeoreferencedForm
    self.model_class = ::RasterWork
  end
end
