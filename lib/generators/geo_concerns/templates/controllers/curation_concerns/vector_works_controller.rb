class CurationConcerns::VectorWorksController < ApplicationController
  include CurationConcerns::CurationConcernController
  include CurationConcerns::ParentContainer
  include GeoConcerns::VectorWorksControllerBehavior
  include GeoConcerns::GeoblacklightControllerBehavior
  self.curation_concern_type = VectorWork
end
