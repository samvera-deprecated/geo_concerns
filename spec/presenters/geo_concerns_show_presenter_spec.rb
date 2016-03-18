require 'rails_helper'

RSpec.describe GeoConcernsShowPresenter do
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

  describe "#external_metadata_file_formats_presenters" do
    let(:obj) { create(:raster_work_with_metadata_files) }
    let(:attributes) { obj.to_solr }
    subject { described_class.new(solr_document, ability) }

    it "returns external_metadata_file_formats_presenters" do
      expect(subject.external_metadata_file_formats_presenters.count).to eq 2
    end
  end
end
