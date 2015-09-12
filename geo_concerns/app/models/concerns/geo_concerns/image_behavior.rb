module GeoConcerns
  module ImageBehavior
    extend ActiveSupport::Concern
    include ::CurationConcerns::GenericWorkBehavior
    include ::CurationConcerns::BasicMetadata
    include ::GeoConcerns::BasicGeoMetadata

    included do
      property :width, predicate: RDF::Vocab::EXIF.width
      property :height, predicate: RDF::Vocab::EXIF.height

      # validates :width, presence: { message: 'Your work must have a width.' }
      # validates :height, presence: { message: 'Your work must have a height.' }
      # filters_association :members, as: :image_files, condition: :concerns_image_file?
      filters_association :related_objects, as: :rasters, condition: :concerns_raster?
    end

    def image_file
      members.find { |parent| parent.class.included_modules.include?(GeoConcerns::ImageFileBehavior) }
    end

    def image
      parents.find { |parent| parent.class.included_modules.include?(GeoConcerns::ImageBehavior) }
    end

    # def rasters
    #  aggregates.find { |parent| parent.class.included_modules.include?(GeoConcerns::ImageFileBehavior) }
    # end
  end
end
