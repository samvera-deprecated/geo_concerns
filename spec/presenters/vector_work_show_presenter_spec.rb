require 'spec_helper'

RSpec.describe ::GeoConcerns::VectorWorkShowPresenter do
  let(:solr_document) { SolrDocument.new(attributes) }
  let(:ability) { nil }

  describe "delegated methods" do
    let(:attributes)  { { "mime_type_ssi" => ['application/zip; ogr-format="ESRI Shapefile"'] } }
    subject { described_class.new(solr_document, ability) }

    describe "#first" do
      it "delegates to solr document" do
        expect(subject.first('mime_type_ssi')).to eq('application/zip; ogr-format="ESRI Shapefile"')
      end
    end

    describe "#has?" do
      it "delegates to solr document" do
        expect(subject.has?('mime_type_ssi')).to be_truthy
      end
    end
  end

  describe "file presenters" do
    let(:obj) { FactoryGirl.create(:vector_work_with_vector_and_metadata_files) }
    let(:attributes) { obj.to_solr }
    subject { described_class.new(solr_document, ability) }

    describe "#vector_file_presenters" do
      it "returns only vector file presenters" do
        expect(subject.vector_file_presenters.count).to eq 2
      end
    end

    describe "#external_metadata_file_formats_presenters" do
      it "returns only external_metadata_file_formats_presenters" do
        expect(subject.external_metadata_file_formats_presenters.count).to eq 2
      end
    end
  end
end
