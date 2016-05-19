module GeoConcerns
  class GeoConcernsShowPresenter < CurationConcerns::WorkShowPresenter
    delegate :has?, :first, to: :solr_document
    delegate :spatial, :temporal, :issued, :coverage, :provenance, to: :solr_document

    def members(presenter)
      # TODO: member ids appear twice in member_ids_ssim.
      # Figure out why instead of removing duplicates.
      ids = solr_document.fetch('member_ids_ssim', [])
      CurationConcerns::PresenterFactory.build_presenters(ids.uniq,
                                                          presenter,
                                                          current_ability)
    end

    def external_metadata_file_formats_presenters
      # filter for external metadata files
      members(::FileSetPresenter).select do |member|
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
