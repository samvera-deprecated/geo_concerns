class RasterWorkShowPresenter < GeoConcernsShowPresenter
  def vector_work_presenters
    # filter for vector works
    members(::VectorWorkShowPresenter).select do |member|
      format = member.solr_document[:has_model_ssim]
      format ? format.first == 'VectorWork' : false
    end
  end

  def raster_file_presenters
    # filter for raster files
    members(::FileSetPresenter).select do |member|
      format = member.solr_document[:geo_file_format_tesim]
      format ? FileSet.raster_file_formats.include?(format.first) : false
    end
  end
end
