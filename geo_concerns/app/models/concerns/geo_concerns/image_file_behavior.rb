module GeoConcerns
  module ImageFileBehavior
    extend ActiveSupport::Concern
    include Hydra::Works::GenericFileBehavior # Added
    include ::CurationConcerns::BasicMetadata
    include ::CurationConcerns::GenericFileBehavior

    included do
      # associated_with :image (derived from, optional)

      # property :resolution, Float
      # ...
    end

    # @return [Boolean] whether this instance is a GeoConcerns Raster File.
    def concerns_image_file?
      true
    end
  end
end
