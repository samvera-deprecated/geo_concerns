module GeoConcerns
  module ImageWorksControllerBehavior
    extend ActiveSupport::Concern

    included do
      self.show_presenter = GeoConcerns::ImageWorkShowPresenter
    end

    def form_class
      GeoConcerns::ImageWorkForm
    end
  end
end
