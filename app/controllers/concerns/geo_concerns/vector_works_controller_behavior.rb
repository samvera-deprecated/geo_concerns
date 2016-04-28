module GeoConcerns
  module VectorWorksControllerBehavior
    extend ActiveSupport::Concern

    included do
      self.show_presenter = GeoConcerns::VectorWorkShowPresenter
    end

    def create
      super

      return unless parent_id
      parent = ActiveFedora::Base.find(parent_id, cast: true)
      parent.ordered_members << curation_concern.reload
      parent.save
      curation_concern.update_index
    end

    def form_class
      GeoConcerns::VectorWorkForm
    end
  end
end
