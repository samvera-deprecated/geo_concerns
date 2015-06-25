module GeoHydraWorks
  module ScannedImageBehavior
    extend ActiveSupport::Concern
    include Hydra::Works::GenericWorkBehavior
    include GeoHydraWorks::GeoProperties

    included do
      type [RDFVocabularies::PCDMTerms.Object,WorksVocabularies::WorksTerms.GenericWork,GeoVocabularies::GeoTerms.ScannedImage]    
    end

  end
end
