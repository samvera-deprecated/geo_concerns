# Model for the GenericFile
class GenericFile < ActiveFedora::Base
  include ::CurationConcerns::FileSetBehavior
end
