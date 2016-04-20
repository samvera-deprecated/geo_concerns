module GeoConcerns
  module Processors
    module Vector
      extend ActiveSupport::Autoload

      eager_autoload do
        autoload :Processor
      end
    end
  end
end
