module GeoConcerns
  module FileSet
    module Derivatives
      extend ActiveSupport::Concern

      def create_derivatives(filename)
        case geo_mime_type
        when *GeoConcerns::RasterFormatService.select_options.map(&:last)
          raster_derivatives(filename)
        when *GeoConcerns::VectorFormatService.select_options.map(&:last)
          vector_derivatives(filename)
        end
        super

        # Once all the derivatives are created, send a derivatives created message
        geo_concerns_messenger.derivatives_created(self)
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

        def geo_concerns_messenger
          @geo_concerns_messenger ||= GeoConcerns::Messaging.messenger
        end
    end
  end
end
