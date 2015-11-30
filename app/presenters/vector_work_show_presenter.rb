class VectorWorkShowPresenter < CurationConcerns::WorkShowPresenter
  def vector_file_presenters

    # get all file presenters
    file_presenters

    # filter for external vector files
    @file_sets.select do |file_set|
      FileSet.vector_file_formats.include? file_set
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

  def file_presenter_class
    FileSetPresenter
  end
end
