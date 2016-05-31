module GeoConcerns
  module Discovery
    class DocumentBuilder
      class DocumentHelper
        include Rails.application.routes.url_helpers
        include ActionDispatch::Routing::PolymorphicRoutes
      end
    end
  end
end
