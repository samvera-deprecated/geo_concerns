class CurationConcerns::ImageWorksController < ApplicationController
  include CurationConcerns::CurationConcernController
  include GeoConcerns::ImageWorksControllerBehavior
  include GeoConcerns::GeoblacklightControllerBehavior
  self.curation_concern_type = ImageWork
end
