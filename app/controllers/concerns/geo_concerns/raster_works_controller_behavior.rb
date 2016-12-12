module GeoConcerns
  module RasterWorksControllerBehavior
    extend ActiveSupport::Concern

    included do
      self.show_presenter = GeoConcerns::RasterWorkShowPresenter
    end

    # For backwards compatibility with CurationConcerns =< 1.6.3
    def form_class
      CurationConcerns::RasterWorkForm
    end
  end
end
