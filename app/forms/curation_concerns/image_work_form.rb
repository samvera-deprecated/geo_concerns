# Generated via
#  `rails generate curation_concerns:work ImageWork`
module CurationConcerns
  class ImageWorkForm < CurationConcerns::Forms::WorkForm
    include BasicGeoMetadataForm
    self.model_class = ::ImageWork
  end
end
