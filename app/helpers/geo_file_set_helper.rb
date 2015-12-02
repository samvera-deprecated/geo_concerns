module GeoFileSetHelper
  def geo_parent_work?
    ['VectorWork', 'RasterWork', 'ImageWork'].include? parent.class.to_s
  end
end
