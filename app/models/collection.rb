# Model for logical Collections of Work or File resources
class Collection < ActiveFedora::Base
  include ::CurationConcerns::CollectionBehavior
  # You can replace these metadata if they're not suitable
  include Hydra::Collections::BasicMetadata
end
