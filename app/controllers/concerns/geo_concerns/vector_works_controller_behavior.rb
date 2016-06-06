module GeoConcerns
  module VectorWorksControllerBehavior
    extend ActiveSupport::Concern

    included do
      self.show_presenter = GeoConcerns::VectorWorkShowPresenter
    end

    def form_class
      GeoConcerns::VectorWorkForm
    end
  end
end
