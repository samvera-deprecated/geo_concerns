module GeoConcerns
  module PopulateMetadataHelper
    def external_metadata_file_presenters
      GeoConcernsShowPresenter.new(curation_concern, nil).external_metadata_file_set_presenters
    end
  end
end
