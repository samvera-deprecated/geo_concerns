class CurationConcerns::VectorWorksController < ApplicationController
  include CurationConcerns::CurationConcernController
  include CurationConcerns::ParentContainer
  include GeoConcerns::VectorWorksController
  self.curation_concern_type = VectorWork

  def show_presenter
    ::GeoConcerns::VectorWorkShowPresenter
  end
end
