require 'spec_helper'

describe SolrDocument do
  let(:document) { described_class.new(attributes) }

  describe "spatial" do
    let(:attributes) { { Solrizer.solr_name('spatial') => ['one', 'two'] } }
    subject { document.spatial }
    it { is_expected.to match_array ['one', 'two'] }
  end

  describe "temporal" do
    let(:attributes) { { Solrizer.solr_name('temporal') => ['one', 'two'] } }
    subject { document.temporal }
    it { is_expected.to match_array ['one', 'two'] }
  end

  describe "issued" do
    let(:attributes) { { Solrizer.solr_name('issued') => 'one' } }
    subject { document.issued }
    it { is_expected.to eq 'one' }
  end

  describe "coverage" do
    let(:attributes) { { Solrizer.solr_name('coverage') => 'one' } }
    subject { document.coverage }
    it { is_expected.to eq 'one' }
  end

  describe "provenance" do
    let(:attributes) { { Solrizer.solr_name('provenance') => 'one' } }
    subject { document.provenance }
    it { is_expected.to eq 'one' }
  end
end
