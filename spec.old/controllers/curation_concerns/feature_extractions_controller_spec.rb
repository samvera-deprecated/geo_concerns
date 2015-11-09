require 'spec_helper'
describe CurationConcerns::FeatureExtractionsController do
  it "has correct concern type" do
    expect(subject.curation_concern_type).to eq FeatureExtraction
  end
end
