module ImageBehavior
  extend ActiveSupport::Concern
  include ::CurationConcerns::GenericWorkBehavior
  include ::CurationConcerns::BasicMetadata
  include ::BasicGeoMetadata

  included  do 
    # property :height, Integer
    # property :width, Integer
    # ...
  end
end
