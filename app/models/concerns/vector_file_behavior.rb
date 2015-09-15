# Attributes and methods for vector files
module VectorFileBehavior
  extend ActiveSupport::Concern
  include Hydra::Works::GenericFileBehavior
  include ::CurationConcerns::GenericFileBehavior
  include ::BasicGeoMetadata
  include ::GeoreferencedBehavior

  # Inspects whether or not this Object is a Vector Work
  # @return [Boolean]
  def concerns_vector?
    false
  end

  # Inspects whether or not this Object is a Vector File
  # @return [Boolean]
  def concerns_vector_file?
    true
  end

  # Retrieve the Vector Work of which this Object is a member
  # @return [GeoConcerns::Vector]
  def vector
    parents.find { |parent| parent.class.included_modules.include?(::VectorBehavior) }
  end
end
