module GeoHydraWorks
  module VectorBehavior
    extend ActiveSupport::Concern
    include Hydra::Works::GenericWork
    include GeoHydraWorks::GeoProperties

    included do
      type [RDFVocabularies::PCDMTerms.Object,WorksVocabularies::WorksTerms.GenericWork,GeoVocabularies::GeoTerms.Vector]
    end

  end
end
