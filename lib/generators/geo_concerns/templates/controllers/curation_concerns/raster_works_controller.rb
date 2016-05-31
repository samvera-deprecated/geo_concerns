class CurationConcerns::RasterWorksController < ApplicationController
  include CurationConcerns::CurationConcernController
  include CurationConcerns::ParentContainer
  include GeoConcerns::RasterWorksControllerBehavior
  include GeoConcerns::GeoblacklightControllerBehavior
  self.curation_concern_type = RasterWork
end
