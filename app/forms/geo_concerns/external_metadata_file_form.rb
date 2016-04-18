module GeoConcerns
  module ExternalMetadataFileForm
    extend ActiveSupport::Concern
    included do
      self.terms += [:should_populate_metadata]
    end
  end
end
