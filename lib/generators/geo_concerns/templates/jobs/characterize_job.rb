class CharacterizeJob < ActiveJob::Base
  queue_as CurationConcerns.config.ingest_queue_name

  # @param [FileSet] file_set
  # @param [String] filename a local path for the file to characterize.
  # rubocop:disable Metrics/AbcSize
  def perform(file_set, file_id)
    filename = CurationConcerns::WorkingDirectory.find_or_retrieve(file_id, file_set.id)
    error_msg = "#{file_set.class.characterization_proxy} was not found"
    raise(LoadError, error_msg) unless file_set.characterization_proxy?
    Hydra::Works::CharacterizationService.run(file_set.characterization_proxy, filename)
    Rails.logger.debug "Ran characterization on #{file_set.characterization_proxy.id} "\
                       "(#{file_set.characterization_proxy.mime_type})"
    file_set.save!
    file_set.update_index
    CreateDerivativesJob.perform_later(file_set, file_id)
  end
  # rubocop:enable Metrics/AbcSize
end
