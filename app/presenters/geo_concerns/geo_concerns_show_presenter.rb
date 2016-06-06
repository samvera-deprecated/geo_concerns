module GeoConcerns
  class GeoConcernsShowPresenter < CurationConcerns::WorkShowPresenter
    delegate :spatial, :temporal, :issued, :coverage, :provenance, to: :solr_document
    class_attribute :file_format_service

    def geo_file_set_presenters
      # filter for geo file sets
      file_set_presenters.select do |member|
        file_format_service.include? member.solr_document[:geo_mime_type_tesim][0]
      end
    end

    def external_metadata_file_set_presenters
      # filter for external metadata files
      file_set_presenters.select do |member|
        MetadataFormatService.include? member.solr_document[:geo_mime_type_tesim][0]
      end
    end

    def attribute_to_html(field, options = {})
      if field == :coverage
        GeoConcerns::CoverageRenderer.new(field, send(field), options).render
      else
        super field, options
      end
    end
  end
end
