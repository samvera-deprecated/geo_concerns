module GeoConcerns
  module FileSetsControllerBehavior
    extend ActiveSupport::Concern
    included do
      self.show_presenter = ::FileSetPresenter
      self.form_class = CurationConcerns::Forms::FileSetEditForm
    end

    # inject mime_type into permitted params
    def file_set_params
      super.tap do |permitted_params|
        permitted_params[:geo_mime_type] = params[:file_set][:geo_mime_type]
      end
    end

    def actor
      @actor ||= GeoConcerns::Actors::FileSetActor.new(@file_set, current_user)
    end
  end
end
