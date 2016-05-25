module GeoConcerns
  module Discovery
    class DocumentBuilder
      class CompositeBuilder
        attr_reader :services

        def initialize(*services)
          @services = services.compact
        end

        # Runs each builder service to build a discovery document.
        # @param [AbstractDocument] discovery document
        def build(document)
          services.each do |service|
            service.build(document)
          end
        end
      end
    end
  end
end
