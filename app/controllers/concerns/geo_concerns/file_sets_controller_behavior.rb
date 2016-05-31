module GeoConcerns
  module FileSetsControllerBehavior
    extend ActiveSupport::Concern
    included do
      self.show_presenter = ::FileSetPresenter
      self.form_class = CurationConcerns::Forms::FileSetEditForm
    end

    # Render geo file sets form if parent is a geo work
    def new
      if geo?
        render 'geo_concerns/file_sets/new'
      else
        super
      end
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

    protected

      def geo?
        parent.image_work? || parent.raster_work? || parent.vector_work?
      end
  end
end
