class VectorWorkShowPresenter < GeoConcernsShowPresenter
  def vector_file_presenters
    # filter for vector files
    members(::FileSetPresenter).select do |member|
      format = member.solr_document[:conforms_to_tesim]
      format ? FileSet.vector_file_formats.include?(format.first) : false
    end
  end
end
