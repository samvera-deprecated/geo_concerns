module GeoConcerns
  module FileSetsControllerBehavior
    extend ActiveSupport::Concern
    included do
      self.show_presenter = ::FileSetPresenter
    end

    # inject mime_type into permitted params
    def file_set_params
      super.tap do |permitted_params|
        permitted_params[:mime_type] = params[:file_set][:mime_type]
      end
    end

    def actor
      @actor ||= GeoConcerns::FileSetActor.new(@file_set, current_user)
    end
  end
end
