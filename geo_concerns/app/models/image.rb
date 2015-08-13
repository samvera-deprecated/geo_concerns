# Base class for Images that are georeferenced with a bbox
class Image < ActiveFedora::Base
  include ::GeoConcerns::ImageBehavior
  validates_presence_of :title,  message: 'Your work must have a title.'
  validates_presence_of :georss_box,  message: 'Your work must have a bbox.'
end

