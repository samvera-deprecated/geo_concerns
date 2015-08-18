module ImageBehavior
  extend ActiveSupport::Concern
  include ::CurationConcerns::GenericWorkBehavior
  include ::CurationConcerns::BasicMetadata
  include ::BasicGeoMetadata

  included  do 
    validates_presence_of :width,  message: 'Your work must have a width.'
    validates_presence_of :height,  message: 'Your work must have a height.'
  end
end
