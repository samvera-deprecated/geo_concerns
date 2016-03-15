module CurationConcerns
  module BasicGeoMetadataForm
    extend ActiveSupport::Concern

    included do
      self.terms += [:coverage]
    end
  end
end
