module GeoHydraWorks
  module GeoProperties
    extend ActiveSupport::Concern
    include ActiveFedora::WithMetadata

    metadata do
      property :identifier, predicate: GeoVocabularies::DublinCoreElements.identifier
      property :title, predicate: GeoVocabularies::DublinCoreElements.title
      property :description, predicate: GeoVocabularies::DublinCoreElements.description
      property :rights, predicate: GeoVocabularies::DublinCoreElements.rights
      property :creator, predicate: GeoVocabularies::DublinCoreElements.creator
      property :format, predicate: GeoVocabularies::DublinCoreElements.format
      property :language, predicate: GeoVocabularies::DublinCoreElements.language
      property :publisher, predicate: GeoVocabularies::DublinCoreElements.publisher
      property :relation, predicate: GeoVocabularies::DublinCoreElements.relation
      property :subject, predicate: GeoVocabularies::DublinCoreElements.subject
      property :type, predicate: GeoVocabularies::DublinCoreElements.type

      property :provenance, predicate: GeoVocabularies::DublinCoreTerms.provenance
      property :references, predicate: GeoVocabularies::DublinCoreTerms.references
      property :spatial, predicate: GeoVocabularies::DublinCoreTerms.spatial
      property :temporal, predicate: GeoVocabularies::DublinCoreTerms.temporal
      property :isssued, predicate: GeoVocabularies::DublinCoreTerms.issued
      property :isPartOf, predicate: GeoVocabularies::DublinCoreTerms.isPartOf

      property :box, predicate: GeoVocabularies::GeoRSSTerms.box
      property :point, predicate: GeoVocabularies::GeoRSSTerms.point
      property :polygon, predicate: GeoVocabularies::GeoRSSTerms.polygon

      property :id, predicate: GeoVocabularies::LayerTerms.id
      property :geom_type, predicate: GeoVocabularies::LayerTerms.geom_type
      property :modified, predicate: GeoVocabularies::LayerTerms.modified
      property :slug, predicate: GeoVocabularies::LayerTerms.slug
    end

  end
end
