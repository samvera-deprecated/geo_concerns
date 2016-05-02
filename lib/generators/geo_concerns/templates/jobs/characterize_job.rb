class CharacterizeJob < ActiveJob::Base
  queue_as :characterize

  # @param [FileSet] file_set
  # @param [String] filename a local path for the file to characterize.
  def perform(file_set, filename)
    Hydra::Works::CharacterizationService.run(file_set, filename)
    file_set.mime_type = file_set.original_file.mime_type
    file_set.save!
    CreateDerivativesJob.perform_later(file_set, filename)
  end
end
