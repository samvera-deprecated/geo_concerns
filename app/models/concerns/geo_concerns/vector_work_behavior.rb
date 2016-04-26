module GeoConcerns
  # Attributes and methods for vector works
  module VectorWorkBehavior
    extend ActiveSupport::Concern
    include ::GeoConcerns::MetadataExtractionHelper

    included do
      type [Hydra::PCDM::Vocab::PCDMTerms.Object,
            Hydra::Works::Vocab::WorksTerms.GenericWork,
            ::GeoConcerns::GeoTerms.VectorWork]
    end

    def vector_files
      members.select(&:vector_file?)
    end

    def metadata_files
      members.select(&:external_metadata_file?)
    end

    # Defines type by what it is and isn't
    # @return [Boolean]
    def image_work?
      false
    end

    def image_file?
      false
    end

    def raster_work?
      false
    end

    def raster_file?
      false
    end

    def vector_work?
      true
    end

    def vector_file?
      false
    end

    def external_metadata_file?
      false
    end

    # Retrieve all Raster Works for which this Vector Work can be extracted
    # @return [Array]
    def raster_works
      ordered_by.select do |parent|
        parent.class.included_modules.include?(::GeoConcerns::RasterWorkBehavior)
      end
    end

    # Retrieve the only Raster Work for which feature extraction generates this Vector Work
    # @return [GeoConcerns::RasterWork]
    def raster_work
      raster_works.first
    end

    def to_solr(solr_doc = {})
      super.tap do |doc|
        doc[solr_name("ordered_by", :symbol)] ||= []
        doc[solr_name("ordered_by", :symbol)] += send(:ordered_by_ids)
      end
    end

    private

      def solr_name(*args)
        ActiveFedora.index_field_mapper.solr_name(*args)
      end
  end
end
