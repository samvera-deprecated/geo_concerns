class ImageWorkShowPresenter < CurationConcerns::WorkShowPresenter
  def raster_work_presenters
    @raster_works ||= begin
      ids = solr_document.fetch('member_ids_ssim', [])

      # TODO: Raster work member ids appear twice in member_ids_ssim.
      # Figure out why instead of removing duplicates.
      CurationConcerns::PresenterFactory.build_presenters(ids.uniq,
                                                          ::RasterWorkShowPresenter,
                                                          current_ability)
    end

    @raster_works.select do |raster_work|
      format = raster_work.solr_document[:has_model_ssim]
      format ? format.first == 'RasterWork' : false
    end
  end

  def image_file_presenters
    # get all file presenters
    file_presenters

    # filter for image files
    @file_sets.select do |file_set|
      format = file_set.solr_document[:geo_file_format_tesim]
      format ? FileSet.image_file_formats.include?(format.first) : false
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
