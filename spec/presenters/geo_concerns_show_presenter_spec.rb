require 'spec_helper'

RSpec.describe ::GeoConcerns::GeoConcernsShowPresenter do
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

  describe "#attribute_to_html" do
    let(:attributes) { FactoryGirl.create(:raster_work).to_solr }
    let(:attribute_renderer) { double('attribute_renderer') }
    let(:coverage_renderer) { double('coverage_renderer') }

    subject { described_class.new(solr_document, ability) }

    before do
      allow(CurationConcerns::Renderers::AttributeRenderer).to receive(:new).and_return(attribute_renderer)
      allow(GeoConcerns::CoverageRenderer).to receive(:new).and_return(coverage_renderer)
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
