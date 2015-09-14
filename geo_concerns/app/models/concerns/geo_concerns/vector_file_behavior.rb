module GeoConcerns
  module VectorFileBehavior
    extend ActiveSupport::Concern
    include Hydra::Works::GenericFileBehavior # Added
    include ::CurationConcerns::GenericFileBehavior
    include ::GeoConcerns::BasicGeoMetadata
    include ::GeoConcerns::GeoreferencedBehavior

    def concerns_vector?
      false
    end

    # @return [Boolean] whether this instance is a GeoConcerns Vector File.
    def concerns_vector_file?
      true
    end

    def vector
      parents.find { |parent| parent.class.included_modules.include?(GeoConcerns::VectorBehavior) }
    end
  end
end
