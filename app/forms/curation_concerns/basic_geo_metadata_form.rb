module CurationConcerns
  module BasicGeoMetadataForm
    extend ActiveSupport::Concern

    included do
      self.terms += [:spatial, :temporal, :coverage, :issued, :provenance]
    end
  end
end
