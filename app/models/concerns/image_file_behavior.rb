# Attributes and methods for image files
module ImageFileBehavior
  extend ActiveSupport::Concern
  include Hydra::Works::GenericFileBehavior
  include ::CurationConcerns::GenericFileBehavior

  # Inspects whether or not this Object is an Image Work
  # @return [Boolean]
  def concerns_image?
    false
  end

  # Inspects whether or not this Object is a Image File
  # @return [Boolean]
  def concerns_image_file?
    true
  end

  # Retrieve the Image Work of which this Object is a member
  # @return [GeoConcerns::Image]
  def image
    parents.find { |parent| parent.class.included_modules.include?(GeoConcerns::ImageBehavior) }
  end
end
