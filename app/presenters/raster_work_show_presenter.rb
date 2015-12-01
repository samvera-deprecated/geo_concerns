class RasterWorkShowPresenter < CurationConcerns::WorkShowPresenter
  delegate :has?, :first, to: :solr_document

  def vector_work_presenters
    @vector_works ||= begin
      ids = solr_document.fetch('member_ids_ssim', [])
      CurationConcerns::PresenterFactory.build_presenters(ids.uniq,
                                                          ::VectorWorkShowPresenter,
                                                          current_ability)
    end

    @vector_works.select do |vector_work|
      format = vector_work.solr_document[:has_model_ssim]
      format ? format.first == 'VectorWork' : false
    end
  end

  def raster_file_presenters
    # get all file presenters
    file_presenters

    # filter for raster files
    @file_sets.select do |file_set|
      format = file_set.solr_document[:geo_file_format_tesim]
      format ? FileSet.raster_file_formats.include?(format.first) : false
    end
  end

  def external_metadata_file_formats_presenters
    # get all file presenters
    file_presenters

    # filter for external metadata files
    @file_sets.select do |file_set|
      format = file_set.solr_document[:geo_file_format_tesim]
      format ? FileSet.external_metadata_file_formats.include?(format.first) : false
    end
  end
end
