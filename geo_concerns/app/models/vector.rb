# Model for (Works of) geospatial Vector features which bear basic geospatial metadata
class Vector < ActiveFedora::Base
  include ::GeoConcerns::VectorBehavior
end
