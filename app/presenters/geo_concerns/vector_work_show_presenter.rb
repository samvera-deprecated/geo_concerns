module GeoConcerns
  class VectorWorkShowPresenter < GeoConcernsShowPresenter
    def vector_file_presenters
      # filter for vector files
      members(::FileSetPresenter).select do |member|
        VectorFormatService.include? member.solr_document[:geo_mime_type_tesim][0]
      end
    end
  end
end
