require 'spec_helper'

RSpec.describe FileSetPresenter do
  let(:ability) { nil }
  let(:solr_document) { SolrDocument.new }
  subject { described_class.new(solr_document, ability) }

  describe "#label" do
    it "returns nil" do
      expect(subject.label).to be_nil
    end
  end
end
