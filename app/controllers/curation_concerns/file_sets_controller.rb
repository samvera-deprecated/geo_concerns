module CurationConcerns
  class FileSetsController < ApplicationController
    include CurationConcerns::FileSetsControllerBehavior

    # override the show presenter
    def show_presenter
      ::FileSetPresenter
    end

    # this is provided so that implementing application can override this
    # behavior and map params to different attributes
    def update_metadata
      file_attributes = ::FileSetEditForm.model_attributes(attributes)
      actor.update_metadata(file_attributes)
    end

    # override the form class
    def form_class
      CurationConcerns::FileSetEditForm
    end

    # inject geo_file_format into permitted params
    def file_set_params
      super.tap do |permitted_params|
        format_value = params[:file_set][:geo_file_format]
        permitted_params[:geo_file_format] = format_value unless format_value.nil?
      end
    end
  end
end
