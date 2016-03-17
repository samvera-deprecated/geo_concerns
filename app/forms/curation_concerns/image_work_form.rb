# Generated via
#  `rails generate curation_concerns:work ImageWork`
module CurationConcerns
  class ImageWorkForm < CurationConcerns::Forms::WorkForm
    include BasicGeoMetadataForm
    include ExternalMetadataFileForm
    self.model_class = ::ImageWork
  end
end
