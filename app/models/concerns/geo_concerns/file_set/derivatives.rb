module GeoConcerns
  module FileSet
    module Derivatives
      extend ActiveSupport::Concern

      def create_derivatives(filename)
        content_url = nil
        case geo_mime_type
        when *GeoConcerns::ImageFormatService.select_options.map(&:last)
          image_derivatives(filename)
        when *GeoConcerns::RasterFormatService.select_options.map(&:last)
          raster_derivatives(filename)
          content_url = derivative_url('display_raster')
        when *GeoConcerns::VectorFormatService.select_options.map(&:last)
          vector_derivatives(filename)
          content_url = derivative_url('display_vector')
        end

        super

        # Once all the derivatives are created, we can run a job to
        # deliver them to external services
        DeliveryJob.perform_later(self, content_url) if content_url.present?
      end

      def image_derivatives(filename)
        Hydra::Derivatives::ImageDerivatives
          .create(filename, outputs: [{ label: :thumbnail,
                                        id: id,
                                        format: 'png',
                                        size: '200x150>',
                                        url: derivative_url('thumbnail') }])
      end

      def raster_derivatives(filename)
        GeoConcerns::Runners::RasterDerivatives
          .create(filename, outputs: [{ input_format: geo_mime_type,
                                        label: :display_raster,
                                        id: id,
                                        format: 'tif',
                                        url: derivative_url('display_raster') },
                                      { input_format: geo_mime_type,
                                        label: :thumbnail,
                                        id: id,
                                        format: 'png',
                                        size: '200x150',
                                        url: derivative_url('thumbnail') }])
      end

      def vector_derivatives(filename)
        GeoConcerns::Runners::VectorDerivatives
          .create(filename, outputs: [{ input_format: geo_mime_type,
                                        label: :display_vector,
                                        id: id,
                                        format: 'zip',
                                        url: derivative_url('display_vector') },
                                      { input_format: geo_mime_type,
                                        label: :thumbnail,
                                        id: id,
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
