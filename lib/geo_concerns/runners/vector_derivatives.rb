module GeoConcerns
  module Runners
    class VectorDerivatives < Hydra::Derivatives::Runner
      def self.processor_class
        GeoConcerns::Processors::Vector::Processor
      end
    end
  end
end
