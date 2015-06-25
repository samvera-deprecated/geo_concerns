module GeoHydraWorks
  module ScannedImageBehavior
    extend ActiveSupport::Concern
    include Hydra::Works::GenericWorkBehavior

    included do
      type RDFVocabularies::PCDMTerms.Object,WorksVocabularies::WorksTerms.GenericWork,GeoVocabularies::GeoTerms.ScannedImage]    
    end

  end
end
