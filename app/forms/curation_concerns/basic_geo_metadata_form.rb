module CurationConcerns
  module BasicGeoMetadataForm
    extend ActiveSupport::Concern

    included do
      self.terms += [:bounding_box]
    end
  end
end
