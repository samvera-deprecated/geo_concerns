class CurationConcerns::ImageWorksController < ApplicationController
  include CurationConcerns::CurationConcernController
  set_curation_concern_type ImageWork

  def show_presenter
    ::ImageWorkShowPresenter
  end
end
