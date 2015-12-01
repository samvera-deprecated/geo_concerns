class VectorWorkShowPresenter < CurationConcerns::WorkShowPresenter
  delegate :has?, :first, to: :solr_document
  
  def vector_file_presenters
    # get all file presenters
    file_presenters

    # filter for vector files
    @file_sets.select do |file_set|
      format = file_set.solr_document[:geo_file_format_tesim]
      format ? FileSet.vector_file_formats.include?(format.first) : false
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
