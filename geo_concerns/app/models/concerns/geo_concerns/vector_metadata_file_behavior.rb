module GeoConcerns
  module VectorMetadataFileBehavior
    extend ActiveSupport::Concern
    include Hydra::Works::GenericFileBehavior
    include ::CurationConcerns::GenericFileBehavior
    include ::GeoConcerns::MetadataFileBehavior

    def vector
      aggregated_by.find { |parent| parent.class.included_modules.include?(GeoConcerns::VectorBehavior) }
    end
  end
end
