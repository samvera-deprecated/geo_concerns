# Model for logical Collections of Work or File resources
class Collection < ActiveFedora::Base
  include ::CurationConcerns::CollectionBehavior
end
