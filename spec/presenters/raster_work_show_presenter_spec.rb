require 'spec_helper'

RSpec.describe GeoConcerns::RasterWorkShowPresenter do
  let(:solr_document) { SolrDocument.new(attributes) }
  let(:ability) { nil }

  describe "delegated methods" do
    let(:attributes)  { { "geo_mime_type_tesim" => ['image/tiff; gdal-format=GTiff'] } }
    subject { described_class.new(solr_document, ability) }

    describe "#first" do
      it "delegates to solr document" do
        expect(subject.first('geo_mime_type_tesim')).to eq('image/tiff; gdal-format=GTiff')
      end
    end

    describe "#has?" do
      it "delegates to solr document" do
        expect(subject.has?('geo_mime_type_tesim')).to be_truthy
      end
    end
  end

  describe "#work_presenters" do
    let(:obj) { FactoryGirl.create(:raster_work_with_vector_work) }
    let(:attributes) { obj.to_solr }
    subject { described_class.new(solr_document, ability) }

    it "returns vector work presenters" do
      expect(subject.work_presenters.count).to eq 1
      expect(subject.work_presenters.first.first('has_model_ssim')).to eq "VectorWork"
    end
  end

  describe "file presenters" do
    let(:obj) { FactoryGirl.create(:raster_work_with_files_and_metadata_files) }
    let(:attributes) { obj.to_solr }
    subject { described_class.new(solr_document, ability) }

    describe "#geo_file_set_presenters" do
      it "returns only raster file presenters" do
        expect(subject.geo_file_set_presenters.count).to eq 1
      end
    end

    describe "#external_metadata_file_set_presenters" do
      it "returns only external_metadata_file_set_presenters" do
        expect(subject.external_metadata_file_set_presenters.count).to eq 1
      end
    end
  end
end
