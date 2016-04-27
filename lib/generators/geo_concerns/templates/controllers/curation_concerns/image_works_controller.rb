class CurationConcerns::ImageWorksController < ApplicationController
  include CurationConcerns::CurationConcernController
  include GeoConcerns::ImageWorksControllerBehavior
  self.curation_concern_type = ImageWork
end
