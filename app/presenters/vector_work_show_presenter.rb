class VectorWorkShowPresenter < GeoConcernsShowPresenter
  def vector_file_presenters
    # filter for vector files
    members(::FileSetPresenter).select do |member|
      format = member.solr_document[:mime_type_ssi]
      format ? FileSet.ogr_formats.include?(format) : false
    end
  end
end
