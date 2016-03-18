require 'rails_helper'

RSpec.describe RasterWorkShowPresenter do
  let(:solr_document) { SolrDocument.new(attributes) }
  let(:ability) { nil }

  describe "delegated methods" do
    let(:attributes)  { { "conforms_to_tesim" => ["TIFF_GeoTIFF"] } }
    subject { described_class.new(solr_document, ability) }

    describe "#first" do
      it "delegates to solr document" do
        expect(subject.first('conforms_to_tesim')).to eq('TIFF_GeoTIFF')
      end
    end
    
    describe "#has?" do
      it "delegates to solr document" do
        expect(subject.has?('conforms_to_tesim')).to be_truthy
      end
    end
  end

  describe "#vector_work_presenters" do
    let(:obj) { create(:raster_work_with_vector_works) }
    let(:attributes) { obj.to_solr }
    subject { described_class.new(solr_document, ability) }

    it "returns vector work presenters" do
      expect(subject.vector_work_presenters.count).to eq 2
      expect(subject.vector_work_presenters.first.first('has_model_ssim')).to eq "VectorWork"
    end
  end
  
  describe "file presenters" do
    let(:obj) { create(:raster_work_with_files_and_metadata_files) }
    let(:attributes) { obj.to_solr }
    subject { described_class.new(solr_document, ability) }

    describe "#raster_file_presenters" do
      it "returns only raster_file_presenters file presenters" do
        expect(subject.raster_file_presenters.count).to eq 2
      end
    end

    describe "#external_metadata_file_formats_presenters" do
      it "returns only external_metadata_file_formats_presenters" do
        expect(subject.external_metadata_file_formats_presenters.count).to eq 2
      end
    end
  end
end
