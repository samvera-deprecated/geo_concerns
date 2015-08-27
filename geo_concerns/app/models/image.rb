# Base class for Images that are georeferenced with a bbox
class Image < ActiveFedora::Base
  include ::GeoConcerns::ImageBehavior
end

