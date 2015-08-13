# Vector work like shapefiles with attribute tables
class Vector < ActiveFedora::Base
  include ::GeoConcerns::VectorBehavior
  validates_presence_of :title,  message: 'Your work must have a title.'
  validates_presence_of :georss_box,  message: 'Your work must have a bbox.'
end

