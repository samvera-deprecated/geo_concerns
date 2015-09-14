module GeoConcerns
  module ImageFileBehavior
    extend ActiveSupport::Concern
    include Hydra::Works::GenericFileBehavior # Added
    include ::CurationConcerns::GenericFileBehavior

    def concerns_image?
      false
    end

    # @return [Boolean] whether this instance is a GeoConcerns Raster File.
    def concerns_image_file?
      true
    end

    def image
      parents.find { |parent| parent.class.included_modules.include?(GeoConcerns::ImageBehavior) }
    end
  end
end
