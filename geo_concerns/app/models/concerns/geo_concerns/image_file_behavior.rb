module GeoConcerns
  module ImageFileBehavior
    extend ActiveSupport::Concern
    include Hydra::Works::GenericFileBehavior # Added
    include ::CurationConcerns::GenericFileBehavior
    # include ::CurationConcerns::BasicMetadata

    included do
      # associated_with :image (derived from, optional)

      # property :resolution, Float
      # ...
    end

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
