module GeoConcerns
  module Runners
    class RasterDerivatives < Hydra::Derivatives::Runner
      def self.processor_class
        GeoConcerns::Processors::Raster::Processor
      end
    end
  end
end
