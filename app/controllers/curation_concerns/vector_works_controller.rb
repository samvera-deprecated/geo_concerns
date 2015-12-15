class CurationConcerns::VectorWorksController < ApplicationController
  include CurationConcerns::CurationConcernController
  include CurationConcerns::ParentContainer
  set_curation_concern_type VectorWork

  def create
    super

    return unless parent_id
    parent = ActiveFedora::Base.find(parent_id, cast: true)
    parent.ordered_members << curation_concern.reload
    parent.save
    curation_concern.update_index
  end

  def show_presenter
    ::VectorWorkShowPresenter
  end
end
