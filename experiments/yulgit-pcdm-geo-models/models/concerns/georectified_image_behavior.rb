module GeoHydraWorks
  module GeorectifiedImageBehavior
    extend ActiveSupport::Concern
    include GeoHydraWorks::ScannedImageBehavior
    include GeoHydraWorks::GeoProperties

    included do
      type [RDFVocabularies::PCDMTerms.Object,WorksVocabularies::WorksTerms.GenericWork,GeoVocabularies::GeoTerms.ScannedImage,
        GeoVocabularies::GeoTerms.GeorectifiedImage]
    end

  end
end

