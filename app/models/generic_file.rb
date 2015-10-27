# Model for the GenericFile
class GenericFile < ActiveFedora::Base
  # https://github.com/projecthydra-labs/hydra-works/issues/203
  extend ActiveSupport::Concern # Added
  include Hydra::Works::GenericFileBehavior # Added
  include ::CurationConcerns::GenericFileBehavior
end