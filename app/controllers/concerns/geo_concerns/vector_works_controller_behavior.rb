module GeoConcerns
  module VectorWorksControllerBehavior
    extend ActiveSupport::Concern

    included do
      self.show_presenter = GeoConcerns::VectorWorkShowPresenter
    end

    # For backwards compatibility with CurationConcerns =< 1.6.3
    def form_class
      CurationConcerns::VectorWorkForm
    end
  end
end
