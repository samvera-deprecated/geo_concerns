module GeoConcerns
  module Processors
    module Raster
      extend ActiveSupport::Autoload

      eager_autoload do
        autoload :Processor
      end
    end
  end
end
