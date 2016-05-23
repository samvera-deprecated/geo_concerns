module GeoConcerns
  module GeoWorksHelper
    # Returns human readable name of child geo work type.
    # @param [GeoConcernsShowPresenter] geo work show presenter
    # @return[String]
    def child_geo_works_type(presenter)
      case presenter.class.to_s
      when 'GeoConcerns::ImageWorkShowPresenter'
        'Raster'
      when 'GeoConcerns::RasterWorkShowPresenter'
        'Vector'
      end
    end

    # Returns human readable name of geo work type.
    # @param [GeoConcernsShowPresenter] geo work show presenter
    # @return[String]
    def geo_work_type(presenter)
      presenter.human_readable_type.sub('Work', '')
    end
  end
end
