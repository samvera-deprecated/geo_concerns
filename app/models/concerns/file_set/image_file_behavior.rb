# Attributes and methods for image files
module ImageFileBehavior
  extend ActiveSupport::Concern
  # Retrieve the JPEG preview for the raster data set
  # @return [Hydra::PCDM::File]
  # @see Hydra::Works::GenericFile#thumbnail
  def preview
    thumbnail
  end

  # Retrieve the Image Work of which this Object is a member
  # @return [GeoConcerns::ImageWork]
  def image_work
    generic_works.find { |parent| parent.class.included_modules.include?(::ImageWorkBehavior) }
  end
end
