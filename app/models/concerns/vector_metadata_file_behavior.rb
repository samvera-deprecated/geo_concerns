# Attributes and methods for vector metadata files
module VectorMetadataFileBehavior
  extend ActiveSupport::Concern
  include Hydra::Works::GenericFileBehavior
  include ::CurationConcerns::GenericFileBehavior
  include ::MetadataFileBehavior

  # Retrieve the Vector Work of which this Object is a member
  # @return [GeoConcerns::Vector]
  def vector
    aggregated_by.find { |parent| parent.class.included_modules.include?(GeoConcerns::VectorBehavior) }
  end
end
