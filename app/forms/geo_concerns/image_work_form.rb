# Generated via
#  `rails generate curation_concerns:work ImageWork`
module GeoConcerns
  class ImageWorkForm < CurationConcerns::Forms::WorkForm
    include ::GeoConcerns::BasicGeoMetadataForm
    include ::GeoConcerns::ExternalMetadataFileForm
    self.model_class = ::ImageWork
  end
end
