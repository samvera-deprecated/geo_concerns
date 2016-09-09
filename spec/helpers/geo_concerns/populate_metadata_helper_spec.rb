require 'spec_helper'

describe GeoConcerns::GeoWorksHelper do
  let(:helper) { TestingHelper.new }
  let(:show_presenter) { instance_double('ShowPresenter', class: GeoConcerns::GeoConcernsShowPresenter) }
  let(:file_presenter) { instance_double('FilePresenter', class: CurationConcerns::FileSetPresenter) }
  let(:file_presenters) { [file_presenter] }
  before do
    class TestingHelper
      include GeoConcerns::PopulateMetadataHelper

      def curation_concern
      end
    end
  end
  after do
    Object.send(:remove_const, :TestingHelper)
  end

  describe '#external_metadata_file_presenters' do
    before do
      allow(GeoConcerns::GeoConcernsShowPresenter).to receive(:new).and_return(show_presenter)
    end

    it 'returns an array of external_metadata_file_presenters' do
      expect(show_presenter).to receive(:external_metadata_file_set_presenters).and_return(file_presenters)
      expect(helper).to receive(:curation_concern)
      expect(helper.external_metadata_file_presenters).to eq(file_presenters)
    end
  end
end
