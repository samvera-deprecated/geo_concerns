# Attributes and methods for vector works
module VectorBehavior
  extend ActiveSupport::Concern
  include ::CurationConcerns::GenericWorkBehavior
  include ::CurationConcerns::BasicMetadata
  include ::BasicGeoMetadata

  included do
    type Vocab::GeoTerms.Vector

    #specifiy the types of members
    filters_association :members, as: :vector_file, condition: :isType?(:concerns_vector_file)
    filters_association :members, as: :external_metadata_files, condition: :isType?(:concerns_metadata_file)
  end

 # Inspects whether or not this Object is a RasterWork
  # @return [Boolean]
  def isType?(type)
    return true if type==:concerns_vector
    return false
  end

  # Retrieve all Raster Works for which this Vector Work can be extracted
  # @return [Array]
  def rasters
    aggregated_by.select { |parent| parent.class.included_modules.include?(::RasterBehavior) }
  end
end
