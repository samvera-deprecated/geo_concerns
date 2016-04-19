module GeoConcerns
  module FileSet
    module Derivatives
      extend ActiveSupport::Concern

      def create_derivatives(filename)
        case mime_type
        when *ImageFormatService.select_options.map(&:last)
          image_derivatives(filename)
        when *RasterFormatService.select_options.map(&:last)
          raster_derivatives(filename)
        when *VectorFormatService.select_options.map(&:last)
          vector_derivatives(filename)
        end

        super
      end

      def image_derivatives(filename)
        Hydra::Derivatives::ImageDerivatives
          .create(filename, outputs: [{ label: :thumbnail,
                                        format: 'png',
                                        size: '200x150>',
                                        url: derivative_url('thumbnail') }])
      end

      def raster_derivatives(filename)
        GeoConcerns::Runners::RasterDerivatives
          .create(filename, outputs: [{ input_format: mime_type,
                                        label: :thumbnail,
                                        format: 'png',
                                        size: '150x150',
                                        url: derivative_url('thumbnail') }])
      end

      def vector_derivatives(filename)
        GeoConcerns::Runners::VectorDerivatives
          .create(filename, outputs: [{ input_format: mime_type,
                                        label: :thumbnail,
                                        format: 'png',
                                        size: '150x150',
                                        url: derivative_url('thumbnail') }])
      end
    end
  end
end
