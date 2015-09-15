
module ImageBehavior
  extend ActiveSupport::Concern
  include ::CurationConcerns::GenericWorkBehavior
  include ::CurationConcerns::BasicMetadata
  include ::BasicGeoMetadata

  included do
    aggregates :rasters, predicate: RDF::Vocab::ORE.aggregates,
                         class_name: '::GeoConcerns::Raster',
                         type_validator: type_validator
    filters_association :members, as: :image_files, condition: :concerns_image_file?
  end

  def concerns_image?
    true
  end

  def concerns_image_file?
    false
  end

  def image_file
    image_files.first
  end

  def image_file=(_file)
    image_files=([_file])
  end
end
