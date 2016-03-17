module CurationConcerns
  class RasterWorkForm < CurationConcerns::Forms::WorkForm
    include BasicGeoMetadataForm
    include GeoreferencedForm
    include ExternalMetadataFileForm
    self.model_class = ::RasterWork
  end
end
