module GeoConcerns
  module DownloadBehavior
    extend ActiveSupport::Concern
    include CurationConcerns::DownloadBehavior

    # Overrides CurationConcerns::DownloadBehavior#load_file.
    # Uses GeoConcerns::DerivativePath instead of CurationConcerns::DerivativePath.
    # Loads the file specified by the HTTP parameter `:file`.
    # If this object does not have a file by that name, return the default file
    # as returned by {#default_file}
    # @return [ActiveFedora::File, String, NilClass] returns the file or the path to a file
    def load_file
      file_reference = params[:file]
      return default_file unless file_reference
      file_path = GeoConcerns::DerivativePath.derivative_path_for_reference(params[asset_param_key],
                                                                            file_reference)
      File.exist?(file_path) ? file_path : nil
    end
  end
end
