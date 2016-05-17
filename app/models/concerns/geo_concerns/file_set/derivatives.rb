module GeoConcerns
  module FileSet
    module Derivatives
      extend ActiveSupport::Concern

      def create_derivatives(filename)
        case geo_mime_type
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
          .create(filename, outputs: [{ input_format: geo_mime_type,
                                        label: :display_raster,
                                        format: 'tif',
                                        url: derivative_url('display_raster') },
                                      { input_format: geo_mime_type,
                                        label: :thumbnail,
                                        format: 'png',
                                        size: '200x150',
                                        url: derivative_url('thumbnail') }])
      end

      def vector_derivatives(filename)
        GeoConcerns::Runners::VectorDerivatives
          .create(filename, outputs: [{ input_format: geo_mime_type,
                                        label: :display_vector,
                                        format: 'zip',
                                        url: derivative_url('display_vector') },
                                      { input_format: geo_mime_type,
                                        label: :thumbnail,
                                        format: 'png',
                                        size: '200x150',
                                        url: derivative_url('thumbnail') }])
      end

      private

        def derivative_path_factory
          GeoConcerns::DerivativePath
        end
    end
  end
end
