class CurationConcerns::RasterWorksController < ApplicationController
  include CurationConcerns::CurationConcernController
  include CurationConcerns::ParentContainer
  self.curation_concern_type = RasterWork

  def create
    super

    return unless parent_id
    parent = ActiveFedora::Base.find(parent_id, cast: true)
    parent.ordered_members << curation_concern.reload
    parent.save
    curation_concern.update_index
  end

  def show_presenter
    ::RasterWorkShowPresenter
  end

  def search_builder_class
    CurationConcerns::GeoSearchBuilder
  end
end
