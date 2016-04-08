require 'rails_helper'

RSpec.describe GeoConcernsShowPresenter do
  let(:solr_document) { SolrDocument.new(attributes) }
  let(:ability) { nil }

  describe "delegated methods" do
    let(:attributes)  { { "mime_type_ssi" => ['image/tiff; gdal-format=GTiff'] } }
    subject { described_class.new(solr_document, ability) }

    describe "#first" do
      it "delegates to solr document" do
        expect(subject.first('mime_type_ssi')).to eq('image/tiff; gdal-format=GTiff')
      end
    end

    describe "#has?" do
      it "delegates to solr document" do
        expect(subject.has?('mime_type_ssi')).to be_truthy
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

  describe "#attribute_to_html" do
    let(:attributes) { create(:raster_work).to_solr }
    let(:attribute_renderer) { double('attribute_renderer') }
    let(:coverage_renderer) { double('coverage_renderer') }

    subject { described_class.new(solr_document, ability) }

    before do
      allow(CurationConcerns::AttributeRenderer).to receive(:new).and_return(attribute_renderer)
      allow(CoverageRenderer).to receive(:new).and_return(coverage_renderer)
    end

    it "uses a CoverageRenderer when the field is coverage" do
      expect(coverage_renderer).to receive(:render)
      subject.attribute_to_html(:coverage)
    end

    it "uses an AttributeRenderer when the field is not coverage" do
      expect(attribute_renderer).to receive(:render)
      subject.attribute_to_html(:language)
    end
  end
end
