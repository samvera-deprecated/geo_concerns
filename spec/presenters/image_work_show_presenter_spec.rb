require 'rails_helper'

RSpec.describe ImageWorkShowPresenter do
  let(:solr_document) { SolrDocument.new(attributes) }
  let(:ability) { nil }

  describe "delegated methods" do
    let(:attributes)  { { "mime_type_ssi" => ['image/tiff'] } }
    subject { described_class.new(solr_document, ability) }

    describe "#first" do
      it "delegates to solr document" do
        expect(subject.first('mime_type_ssi')).to eq('image/tiff')
      end
    end

    describe "#has?" do
      it "delegates to solr document" do
        expect(subject.has?('mime_type_ssi')).to be_truthy
      end
    end
  end

  describe "#raster_work_presenters" do
    let(:obj) { create(:image_work_with_raster_works) }
    let(:attributes) { obj.to_solr }
    subject { described_class.new(solr_document, ability) }

    it "returns raster work presenters" do
      expect(subject.raster_work_presenters.count).to eq 2
      expect(subject.raster_work_presenters.first.first('has_model_ssim')).to eq "RasterWork"
    end
  end

  describe "file presenters" do
    let(:obj) { create(:image_work_with_files_and_metadata_files) }
    let(:attributes) { obj.to_solr }
    subject { described_class.new(solr_document, ability) }

    describe "#image_file_presenters" do
      it "returns only raster_file_presenters file presenters" do
        expect(subject.image_file_presenters.count).to eq 2
      end
    end

    describe "#external_metadata_file_formats_presenters" do
      it "returns only external_metadata_file_formats_presenters" do
        expect(subject.external_metadata_file_formats_presenters.count).to eq 2
      end
    end
  end
end
