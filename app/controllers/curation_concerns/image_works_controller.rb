class CurationConcerns::ImageWorksController < ApplicationController
  include CurationConcerns::CurationConcernController
  self.curation_concern_type = ImageWork

  def show_presenter
    ::ImageWorkShowPresenter
  end

  def search_builder_class
    CurationConcerns::GeoSearchBuilder
  end
end
