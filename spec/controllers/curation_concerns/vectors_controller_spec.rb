require 'spec_helper'

describe CurationConcerns::VectorsController do
  it "has correct concern type" do
    expect(subject.curation_concern_type).to eq Vector
  end
end
