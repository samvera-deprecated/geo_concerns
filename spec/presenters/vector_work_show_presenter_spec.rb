require 'spec_helper'

RSpec.describe ::GeoConcerns::VectorWorkShowPresenter do
  let(:solr_document) { SolrDocument.new(attributes) }
  let(:ability) { nil }

  describe "delegated methods" do
    let(:attributes)  { { "geo_mime_type_tesim" => ['application/zip; ogr-format="ESRI Shapefile"'] } }
    subject { described_class.new(solr_document, ability) }

    describe "#first" do
      it "delegates to solr document" do
        expect(subject.first('geo_mime_type_tesim')).to eq('application/zip; ogr-format="ESRI Shapefile"')
      end
    end

    describe "#has?" do
      it "delegates to solr document" do
        expect(subject.has?('geo_mime_type_tesim')).to be_truthy
      end
    end
  end

  describe "file presenters" do
    let(:obj) { FactoryGirl.create(:vector_work_with_vector_and_metadata_file) }
    let(:attributes) { obj.to_solr }
    subject { described_class.new(solr_document, ability) }

    describe "#geo_file_set_presenters" do
      it "returns only vector file set presenters" do
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
