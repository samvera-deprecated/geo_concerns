# Attributes and methods for raster works
module RasterBehavior
  extend ActiveSupport::Concern
  include ::CurationConcerns::GenericWorkBehavior
  include ::CurationConcerns::BasicMetadata
  include ::BasicGeoMetadata

  included do
    type [Hydra::PCDM::Vocab::PCDMTerms.Object, Vocab::WorksTerms.GenericWork,Vocab::GeoTerms.Raster]

    #specifiy the types of members
    filters_association :members, as: :raster_file, condition: :isType?(:concerns_raster_file)
    filters_association :members, as: :external_metadata_files, condition: :isType?(:concerns_metadata_file)
    filters_association :members, as: :vector_works, condition: :isType?(:concerns_vector)
  end

 # Inspects whether or not this Object is a RasterWork
  # @return [Boolean]
  def isType?(type)
    return true if type==:concerns_raster
    return false
  end

  # Retrieve all Image Works for which georeferencing generates this Raster Work
  # @return [Array]
  def images
    aggregated_by.select { |parent| parent.class.included_modules.include?(::ImageBehavior) }
  end

  # Retrieve the only Image Works for which georeferencing generates this Raster Work
  # @return [GeoConcerns::Image]
  def image
    images.first
  end
end
