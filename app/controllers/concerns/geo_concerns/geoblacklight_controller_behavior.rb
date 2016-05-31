module GeoConcerns
  module GeoblacklightControllerBehavior
    extend ActiveSupport::Concern

    included do
      def geoblacklight
        respond_to do |f|
          f.json do
            if builder.to_hash.fetch(:error, nil)
              render json: builder, status: 404
            else
              render json: builder
            end
          end
        end
      end
    end

    private

      def document_class
        Discovery::GeoblacklightDocument
      end

      def builder
        @builder ||= Discovery::DocumentBuilder.new(presenter, document_class.new)
      end
  end
end
