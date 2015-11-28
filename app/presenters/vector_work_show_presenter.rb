class VectorWorkShowPresenter < CurationConcerns::WorkShowPresenter
  def vector_file_presenters
    @file_sets.select do |file_set|
      FileSet.vector_file_formats.include? file_set
        .solr_document[:geo_file_format_tesim].first
    end
  end

  def external_metadata_file_formats_presenters
    @file_sets.select do |file_set|
      FileSet.external_metadata_file_formats.include? file_set
        .solr_document[:geo_file_format_tesim].first
    end
  end

  # def file_presenter_class
  #   ::FileSetPresenter
  # end
end
