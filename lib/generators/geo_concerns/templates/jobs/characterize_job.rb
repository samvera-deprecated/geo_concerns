class CharacterizeJob < ActiveJob::Base
  queue_as CurationConcerns.config.ingest_queue_name

  # @param [FileSet] file_set
  # @param [String] filename a local path for the file to characterize.
  def perform(file_set, filename)
    error_msg = "#{file_set.class.characterization_proxy} was not found"
    raise(LoadError, error_msg) unless file_set.characterization_proxy?
    Hydra::Works::CharacterizationService.run(file_set.characterization_proxy, filename)
    file_set.save!
    CreateDerivativesJob.perform_later(file_set, filename)
  end
end
