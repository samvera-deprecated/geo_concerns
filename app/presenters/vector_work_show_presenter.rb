class VectorWorkShowPresenter < GeoConcernsShowPresenter
  def vector_file_presenters
    # filter for vector files
    members(::FileSetPresenter).select do |member|
      VectorFormatService.include? member.solr_document[:mime_type_ssi]
    end
  end
end
