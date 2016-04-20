class CurationConcerns::RasterWorksController < ApplicationController
  include CurationConcerns::CurationConcernController
  include CurationConcerns::ParentContainer
  include GeoConcerns::RasterWorkController
  self.curation_concern_type = RasterWork

  def show_presenter
    GeoConcerns::RasterWorkShowPresenter
  end
end
