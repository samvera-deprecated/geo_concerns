require 'spec_helper'

describe GeoConcerns::FileSetActionsHelper do
  let(:helper) { TestingHelper.new }

  before do
    class TestingHelper
      include GeoConcerns::FileSetActionsHelper

      def render(partial, locals = {})
      end
    end
  end

  after do
    Object.send(:remove_const, :TestingHelper)
  end

  let(:presenter) { GeoConcerns::GeoConcernsShowPresenter.new(solr_document, nil) }
  let(:solr_document) { SolrDocument.new(geo_mime_type_ssim: [geo_mime_type]) }

  describe '#file_set_actions' do
    let(:geo_mime_type) { 'image/tiff' }

    before do
      allow(helper).to receive(:file_set_actions_partial).with(presenter)
        .and_return('geo_concerns/file_sets/actions/image_actions')
    end

    it "renders a partial" do
      expect(helper).to receive(:render)
        .with('geo_concerns/file_sets/actions/image_actions', file_set: presenter)
      helper.file_set_actions(presenter)
    end
    it "takes options" do
      expect(helper).to receive(:render)
        .with('geo_concerns/file_sets/actions/image_actions', file_set: presenter, bbox: '123')
      helper.file_set_actions(presenter, bbox: '123')
    end
  end

  describe '#file_set_actions_partial' do
    subject { helper.file_set_actions_partial(presenter) }

    context "with an image file" do
      let(:geo_mime_type) { 'image/tiff' }
      it { is_expected.to eq 'geo_concerns/file_sets/actions/image_actions' }
    end

    context "with a vector file" do
      let(:geo_mime_type) { 'application/vnd.geo+json' }
      it { is_expected.to eq 'geo_concerns/file_sets/actions/vector_actions' }
    end

    context "with a raster file" do
      let(:geo_mime_type) { 'text/plain; gdal-format=USGSDEM' }
      it { is_expected.to eq 'geo_concerns/file_sets/actions/raster_actions' }
    end

    context "with a metadata file" do
      let(:geo_mime_type) { 'application/xml; schema=fgdc' }
      it { is_expected.to eq 'geo_concerns/file_sets/actions/metadata_actions' }
    end

    context "with anything else" do
      let(:geo_mime_type) { 'application/binary' }
      it { is_expected.to eq 'geo_concerns/file_sets/actions/default_actions' }
    end
  end
end
