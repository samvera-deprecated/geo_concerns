require 'spec_helper'

describe CurationConcerns::ImagesController do
  it "has correct concern type" do
    expect(subject.curation_concern_type).to eq Image
  end
end
