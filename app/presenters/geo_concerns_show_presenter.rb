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
      format = member.solr_document[:conforms_to_tesim]
      format ? FileSet.external_metadata_file_formats.include?(format.first) : false
    end
  end
end
