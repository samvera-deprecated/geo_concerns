module GeoConcerns::Runners
  class NormalizeDataDerivatives < Hydra::Derivatives::Runner
    def self.processor_class
      GeoConcerns::Processors::NormalizeData
    end
  end
end
