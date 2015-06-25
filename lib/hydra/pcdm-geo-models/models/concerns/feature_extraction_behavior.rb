module GeoHydraWorks
  module FeatureExtractionBehavior
    extend ActiveSupport::Concern
    include GeoHydraWorks::VectorBehavior

    included do
      type RDFVocabularies::PCDMTerms.Object,WorksVocabularies::WorksTerms.GenericWork,GeoVocabularies::GeoTerms.Vector,
        GeoVocabularies::GeoTerms.FeatureExtraction]
    end

  end
end
