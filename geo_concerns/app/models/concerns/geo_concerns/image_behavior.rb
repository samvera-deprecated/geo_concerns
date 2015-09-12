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
      filters_association :members, as: :image_files, condition: :concerns_image_file?
      # filters_association :related_objects, as: :rasters, condition: :concerns_raster?
    end

    def concerns_image?
      true
    end

    def concerns_image_file?
      false
    end

    def image_file
      # Work-around for "Couldn't find ActiveFedora::Base without an ID" ArgumentError when using Array#find
      set = image_files.select { |parent| parent.class.included_modules.include?(GeoConcerns::ImageFileBehavior) }
      set.first
    end

    def image_file=(file)
      image_files [file]
    end

    def rasters
      parents.select { |parent| parent.class.included_modules.include?(GeoConcerns::RasterBehavior) }
    end
  end
end
