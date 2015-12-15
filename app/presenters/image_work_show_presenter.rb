class ImageWorkShowPresenter < GeoConcernsShowPresenter
  def raster_work_presenters
    # filter for raster works
    members(::RasterWorkShowPresenter).select do |member|
      format = member.solr_document[:has_model_ssim]
      format ? format.first == 'RasterWork' : false
    end
  end

  def image_file_presenters
    # filter for image files
    members(::FileSetPresenter).select do |member|
      format = member.solr_document[:geo_file_format_tesim]
      format ? FileSet.image_file_formats.include?(format.first) : false
    end
  end
end
