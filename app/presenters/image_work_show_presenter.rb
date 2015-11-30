class ImageWorkShowPresenter < CurationConcerns::WorkShowPresenter
  def image_file_presenters

    # get all file presenters
    file_presenters

    # filter for raster files
    @file_sets.select do |file_set|
      FileSet.image_file_formats.include? file_set
        .solr_document[:geo_file_format_tesim].first
    end
  end

  def external_metadata_file_formats_presenters
    
    # get all file presenters
    file_presenters

    # filter for external metadata files
    @file_sets.select do |file_set|
      FileSet.external_metadata_file_formats.include? file_set
        .solr_document[:geo_file_format_tesim].first
    end
  end
end
