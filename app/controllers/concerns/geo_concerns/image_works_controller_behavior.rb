module GeoConcerns
  module ImageWorksControllerBehavior
    extend ActiveSupport::Concern

    included do
      self.show_presenter = GeoConcerns::ImageWorkShowPresenter
    end

    # For backwards compatibility with CurationConcerns =< 1.6.3
    def form_class
      CurationConcerns::ImageWorkForm
    end
  end
end
