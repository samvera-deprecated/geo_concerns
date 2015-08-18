# Vector work like shapefiles with attribute tables
class Vector < ActiveFedora::Base
  include ::GeoConcerns::VectorBehavior
end

