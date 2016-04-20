class CurationConcerns::ImageWorksController < ApplicationController
  include CurationConcerns::CurationConcernController
  self.curation_concern_type = ImageWork

  def show_presenter
    ::GeoConcerns::ImageWorkShowPresenter
  end

  def form_class
    GeoConcerns::ImageWorkForm
  end
end
